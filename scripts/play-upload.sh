#!/usr/bin/env bash
# AAB を Google Play の内部テストトラックにアップロードする。
#
# fastlane や Google のクライアントライブラリは入れず、curl と openssl だけで
# Play Developer API v3 を直接叩く。手順は次のとおり。
#
#   1. サービスアカウント鍵で JWT を作り、アクセストークンと交換する
#   2. edit を作る
#   3. AAB をアップロードする
#   4. トラックに versionCode を載せる
#   5. edit を commit する（ここで初めて反映される）
#
# commit するまでは何も公開されないので、途中で落ちても影響はない。
#
# 使い方:
#   AWS_PROFILE=reaction-production scripts/play-upload.sh <app-release.aab>
#
#   TRACK=internal          … 対象トラック（既定 internal）
#   RELEASE_NOTES_FILE=...  … リリースノート（省略時は既定の文面）
#   STATUS=completed        … draft にすると Play Console で手動公開になる
set -euo pipefail

package=com.swiswiswift.chemist
track="${TRACK:-internal}"
status="${STATUS:-completed}"
api=https://androidpublisher.googleapis.com/androidpublisher/v3/applications
upload_api=https://androidpublisher.googleapis.com/upload/androidpublisher/v3/applications

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$repo_root"

aab="${1:-}"
[ -n "$aab" ] || { echo "usage: $0 <app-release.aab>" >&2; exit 2; }
[ -f "$aab" ] || { echo "missing: $aab" >&2; exit 1; }

work=""
cleanup() {
  if [ -n "$work" ]; then
    rm -rf "$work"
    work=""
  fi
}
work="$(mktemp -d)"
chmod 700 "$work"
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

echo "==> サービスアカウント鍵を取得"
# eval "$(...)" と直接書くと pull の失敗を検知できないので、
# コマンド置換の終了コードを先に確認する。
exports="$(./scripts/play-credentials.sh pull "$work")"
eval "$exports"

echo "==> アクセストークンを取得"
# サービスアカウントの秘密鍵で RS256 署名した JWT を作り、
# Google のトークンエンドポイントでアクセストークンに交換する。
# 秘密鍵は argv に載せず、ファイル経由で openssl に渡す。
python3 - "$PLAY_SERVICE_ACCOUNT_JSON" "$work" <<'PY'
import base64, json, sys, os

sa_path, work = sys.argv[1], sys.argv[2]
sa = json.load(open(sa_path))

def b64(data: bytes) -> bytes:
    return base64.urlsafe_b64encode(data).rstrip(b"=")

import time
now = int(time.time())
header = {"alg": "RS256", "typ": "JWT"}
claims = {
    "iss": sa["client_email"],
    "scope": "https://www.googleapis.com/auth/androidpublisher",
    "aud": sa["token_uri"],
    "iat": now,
    "exp": now + 3600,
}
signing_input = b64(json.dumps(header).encode()) + b"." + b64(json.dumps(claims).encode())

# 秘密鍵と署名対象をファイルに置いて openssl に渡す
key_path = os.path.join(work, "sa-key.pem")
fd = os.open(key_path, os.O_WRONLY | os.O_CREAT | os.O_TRUNC, 0o600)
with os.fdopen(fd, "w") as f:
    f.write(sa["private_key"])
with open(os.path.join(work, "signing-input"), "wb") as f:
    f.write(signing_input)
with open(os.path.join(work, "token-uri"), "w") as f:
    f.write(sa["token_uri"])
PY

openssl dgst -sha256 -sign "$work/sa-key.pem" -out "$work/signature" "$work/signing-input"
signature="$(base64 < "$work/signature" | tr -d '\n' | tr '+/' '-_' | tr -d '=')"
jwt="$(cat "$work/signing-input").$signature"
token_uri="$(cat "$work/token-uri")"

access_token="$(curl -sS -X POST "$token_uri" \
  -d grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer \
  --data-urlencode "assertion=$jwt" \
  | python3 -c 'import json,sys; d=json.load(sys.stdin); print(d.get("access_token") or sys.exit("error: %s" % d))')"

auth="Authorization: Bearer $access_token"

echo "==> edit を作成"
edit_id="$(curl -sS -X POST "$api/$package/edits" -H "$auth" -H "Content-Length: 0" \
  | python3 -c 'import json,sys; d=json.load(sys.stdin); print(d.get("id") or sys.exit("error: %s" % d))')"
echo "  editId=$edit_id"

# ここから先で失敗したら edit を消す。放置すると Play Console に
# 未完了の編集が残り、次回の操作が弾かれることがある。
abandon_edit() {
  curl -sS -X DELETE "$api/$package/edits/$edit_id" -H "$auth" >/dev/null 2>&1 || true
  cleanup
}
trap abandon_edit EXIT

echo "==> AAB をアップロード ($(du -h "$aab" | cut -f1))"
version_code="$(curl -sS -X POST "$upload_api/$package/edits/$edit_id/bundles?uploadType=media" \
  -H "$auth" -H "Content-Type: application/octet-stream" \
  --data-binary "@$aab" \
  | python3 -c 'import json,sys; d=json.load(sys.stdin); print(d.get("versionCode") or sys.exit("error: %s" % d))')"
echo "  versionCode=$version_code"

echo "==> $track トラックに設定"
if [ -n "${RELEASE_NOTES_FILE:-}" ]; then
  [ -f "$RELEASE_NOTES_FILE" ] || { echo "missing: $RELEASE_NOTES_FILE" >&2; exit 1; }
  notes="$(cat "$RELEASE_NOTES_FILE")"
else
  notes="内部テスト向けのビルドです。"
fi

NOTES="$notes" python3 - "$version_code" "$status" "$work/track.json" <<'PY'
import json, os, sys
version_code, status, out = sys.argv[1], sys.argv[2], sys.argv[3]
body = {
    "releases": [
        {
            "versionCodes": [version_code],
            "status": status,
            "releaseNotes": [{"language": "ja-JP", "text": os.environ["NOTES"]}],
        }
    ]
}
json.dump(body, open(out, "w"), ensure_ascii=False)
PY

curl -sS -X PUT "$api/$package/edits/$edit_id/tracks/$track" \
  -H "$auth" -H "Content-Type: application/json" \
  --data-binary "@$work/track.json" \
  | python3 -c 'import json,sys; d=json.load(sys.stdin); sys.exit("error: %s" % d) if "error" in d else None'

echo "==> commit"
curl -sS -X POST "$api/$package/edits/$edit_id:commit" -H "$auth" -H "Content-Length: 0" \
  | python3 -c 'import json,sys; d=json.load(sys.stdin); sys.exit("error: %s" % d) if "error" in d else None'

# commit 済みなので edit を消してはいけない
trap cleanup EXIT
cleanup
trap - EXIT INT TERM

echo
echo "$track トラックに versionCode $version_code を公開しました。"
echo "Play Console に反映されるまで数分かかります。"
