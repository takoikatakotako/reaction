#!/usr/bin/env bash
# AAB を Google Play の内部テストトラックにアップロードする。
#
# fastlane や Google のクライアントライブラリは入れず、curl だけで
# Play Developer API v3 を直接叩く。手順は次のとおり。
#
#   1. サービスアカウントを借用してアクセストークンを取る
#   2. edit を作る
#   3. AAB をアップロードする
#   4. トラックに versionCode を載せる
#   5. edit を commit する（ここで初めて反映される）
#
# commit するまでは何も公開されないので、途中で落ちても影響はない。
#
# 認証は鍵ファイルではなく権限借用（service account impersonation）で行う。
# AWS の AssumeRole に相当する。手元の gcloud の認証情報で play-publisher を
# 借用し、1 時間で失効するトークンを取る。鍵ファイルを作らないので、
# 漏洩も失効管理も保管場所の心配も要らない。
#
# 事前に gcloud で認証しておくこと（gcloud auth login）。借用できるのは
# gcp-iac の play_publisher_impersonators に列挙された principal だけ。
#
# 使い方:
#   scripts/play-upload.sh <app-release.aab>
#
#   TRACK=internal          … 対象トラック（既定 internal）
#   RELEASE_NOTES_FILE=...  … リリースノート（省略時は既定の文面）
#   STATUS=completed        … draft にすると Play Console で手動公開になる
set -euo pipefail

package=com.swiswiswift.chemist
service_account=play-publisher@takoikatakotako-management.iam.gserviceaccount.com
track="${TRACK:-internal}"
status="${STATUS:-completed}"
api=https://androidpublisher.googleapis.com/androidpublisher/v3/applications
upload_api=https://androidpublisher.googleapis.com/upload/androidpublisher/v3/applications

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$repo_root"

aab="${1:-}"
[ -n "$aab" ] || { echo "usage: $0 <app-release.aab>" >&2; exit 2; }
[ -f "$aab" ] || { echo "missing: $aab" >&2; exit 1; }

# 後始末は 1 か所にまとめる。トラップを付け替えると、後から張ったものが
# 前のものを消してしまい、edit が中途半端に残る。
track_json=""
edit_id=""
auth=""
committed=0

cleanup() {
  [ -n "$track_json" ] && rm -f "$track_json"
  # commit 前に落ちたら edit を破棄する。放置すると Play Console に
  # 未完了の編集が残り、次回の操作が弾かれることがある。
  if [ -n "$edit_id" ] && [ "$committed" -eq 0 ]; then
    curl -sS -X DELETE "$api/$package/edits/$edit_id" -H "$auth" >/dev/null 2>&1 || true
  fi
}
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

echo "==> アクセストークンを取得（権限借用）"
# Play Developer API のスコープは cloud-platform に含まれないため、
# gcloud の --impersonate-service-account では足りない。IAM Credentials API の
# generateAccessToken に scope を明示して取る。
#
# ${service_account} と波括弧で囲むこと。zsh では $var:generateAccessToken の
# :g が履歴修飾子として解釈され、URL が壊れて 404 になる。
user_token="$(gcloud auth print-access-token)" || {
  echo "error: gcloud の認証情報がありません。gcloud auth login を実行してください" >&2
  exit 1
}

access_token="$(curl -sS -X POST \
  "https://iamcredentials.googleapis.com/v1/projects/-/serviceAccounts/${service_account}:generateAccessToken" \
  -H "Authorization: Bearer $user_token" \
  -H "Content-Type: application/json" \
  -d '{"scope":["https://www.googleapis.com/auth/androidpublisher"],"lifetime":"3600s"}' \
  | python3 -c 'import json,sys; d=json.load(sys.stdin); print(d.get("accessToken") or sys.exit("error: %s" % d))')"

auth="Authorization: Bearer $access_token"

echo "==> edit を作成"
edit_id="$(curl -sS -X POST "$api/$package/edits" -H "$auth" -H "Content-Length: 0" \
  | python3 -c 'import json,sys; d=json.load(sys.stdin); print(d.get("id") or sys.exit("error: %s" % d))')"
echo "  editId=$edit_id"

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

track_json="$(mktemp)"
NOTES="$notes" python3 - "$version_code" "$status" "$track_json" <<'PY'
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
  --data-binary "@$track_json" \
  | python3 -c 'import json,sys; d=json.load(sys.stdin); sys.exit("error: %s" % d) if "error" in d else None'

echo "==> commit"
# Play は commit に付けるパラメータを、アプリに未審査の変更が残っているか
# どうかで出し分けてくる。どちらかに固定すると、もう一方の状態で 400 になる。
#
#   未審査の変更なし  changesNotSentForReview を付けると must not be set
#   未審査の変更あり  付けないと「changesNotSentForReview を true にしろ」
#
# 実際、プライバシーポリシーの否承認で未審査の変更が残っている間は前者では
# 通らず、承認後は後者では通らなくなった。両方を試す。
#
# 既定は changesInReviewBehavior=ERROR_IF_IN_REVIEW。省略すると
# CANCEL_IN_REVIEW_AND_SUBMIT が効き、審査中の変更をキャンセルして再送信して
# しまう。製品版の審査中に内部テストを上げると巻き込むので、審査中なら止める。
#
# 「set the query parameter changesNotSentForReview」と言われたときだけ
# changesNotSentForReview=true で入れ直す。変更を確定するだけで審査には
# 出さない。内部テストの配信自体は審査を必要としないので、審査に出すか
# どうかは Play Console から人が判断する。
#
# commit が 400 で落ちても edit は無効化されないため、同じ edit で再試行できる。
commit_edit() {
  curl -sS -X POST "$api/$package/edits/$edit_id:commit?$1" \
    -H "$auth" -H "Content-Length: 0"
}

commit_response="$(commit_edit 'changesInReviewBehavior=ERROR_IF_IN_REVIEW')"
if printf '%s' "$commit_response" | grep -q 'set the query parameter changesNotSentForReview'; then
  echo "    未審査の変更が残っているため changesNotSentForReview を付けて再試行"
  commit_response="$(commit_edit 'changesNotSentForReview=true')"
fi

printf '%s' "$commit_response" \
  | python3 -c 'import json,sys; d=json.load(sys.stdin); sys.exit("error: %s" % d) if "error" in d else None'
committed=1

echo
echo "$track トラックに versionCode $version_code を公開しました。"
echo "Play Console に反映されるまで数分かかります。"
