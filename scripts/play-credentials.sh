#!/usr/bin/env bash
# Google Play のサービスアカウント鍵を SSM Parameter Store と手元の間で出し入れする。
# scripts/appstore-connect.sh の Android 版。
#
# パラメータ（SecureString、production アカウント）:
#   /reaction/production/android/play-service-account  … サービスアカウントの JSON
#
# 使い方:
#   exports="$(scripts/play-credentials.sh pull)" && eval "$exports"
#       JSON を一時ディレクトリに復元し、PLAY_SERVICE_ACCOUNT_JSON の
#       export 文を標準出力に出す。
#       eval "$(... pull)" と直接書くと pull の失敗を検知できないので、
#       必ずコマンド置換の終了コードを先に確認すること。
#   scripts/play-credentials.sh push <service-account.json>
#
# 事前に production のプロファイルで認証しておくこと。
set -euo pipefail

region="${AWS_REGION:-ap-northeast-1}"
param="/reaction/production/android/play-service-account"
expected_account=852798039462

usage() {
  echo "usage: $0 pull [dir]" >&2
  echo "         exports=\"\$($0 pull)\" && eval \"\$exports\"" >&2
  echo "       $0 push <service-account.json>" >&2
  exit 2
}

# 間違ったアカウントの同名パスを読み書きしないよう STS で検証する
require_production_account() {
  local actual
  actual="$(aws sts get-caller-identity --query Account --output text 2>/dev/null || true)"
  if [ "$actual" != "$expected_account" ]; then
    echo "error: production は AWS アカウント $expected_account だが、現在の認証情報は ${actual:-取得失敗}" >&2
    echo "       AWS_PROFILE=reaction-production を指定してください" >&2
    exit 1
  fi
}

# eval される export 文を組み立てる。
# シングルクォートで囲むだけでは値に ' が含まれると壊れるため、
# ' を '\'' に置換してから囲む（シェルの標準的なエスケープ）。
emit_export() {
  local name="$1" value="$2" escaped
  escaped=$(printf '%s' "$value" | sed "s/'/'\\\\''/g")
  printf "export %s='%s'\n" "$name" "$escaped"
}

do_pull() {
  local dir="${1:-$(mktemp -d)}"
  local json
  json="$(aws ssm get-parameter --region "$region" --with-decryption \
    --name "$param" --query 'Parameter.Value' --output text)" || return 1

  mkdir -p "$dir"
  chmod 700 "$dir"

  # 最初から mode 600 の一時ファイルへ書き、成功したときだけ本来の名前へ
  # 置き換える。> で直接作ると umask 次第で他ユーザーから読める権限になる。
  local dest tmp
  dest="$dir/play-service-account.json"
  tmp="$(mktemp "$dir/.play.XXXXXX")" || return 1
  if ! printf '%s' "$json" > "$tmp"; then
    rm -f "$tmp"
    return 1
  fi
  chmod 600 "$tmp"
  mv "$tmp" "$dest" || { rm -f "$tmp"; return 1; }

  emit_export PLAY_SERVICE_ACCOUNT_JSON "$dest"
}

do_push() {
  local src="$1"
  [ -f "$src" ] || { echo "missing: $src" >&2; exit 1; }
  require_production_account

  # 登録前に中身を検証する。壊れた値を入れてもアップロード時まで
  # 気づけないため。
  python3 - "$src" <<'PY'
import json, sys
d = json.load(open(sys.argv[1]))
missing = [k for k in ("type", "client_email", "private_key", "token_uri") if k not in d]
if missing:
    sys.exit("error: サービスアカウントの JSON に %s がありません" % ", ".join(missing))
if d["type"] != "service_account":
    sys.exit("error: type が service_account ではありません: %s" % d["type"])
print("  client_email: %s" % d["client_email"])
PY

  # 秘密値はコマンドライン引数に載せない（ps や履歴から見えるため）。
  # ファイル経由で渡す。
  aws ssm put-parameter --region "$region" --type SecureString --overwrite \
    --name "$param" --value "file://$src" >/dev/null

  echo "pushed $param"
  echo
  echo "JSON は SSM に入ったので、手元から消して構いません:"
  echo "  rm $src"
}

action="${1:-}"
case "$action" in
  pull) require_production_account; do_pull "${2:-}" ;;
  push) [ $# -ge 2 ] || usage; do_push "$2" ;;
  *) usage ;;
esac
