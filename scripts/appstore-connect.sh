#!/usr/bin/env bash
# App Store Connect API キーを SSM Parameter Store と手元の間で出し入れする。
# scripts/android-signing.sh の iOS 版。
#
# SSM がマスター。pull は TestFlight へアップロードするときに使う。
#
# パラメータ（すべて SecureString、production アカウント）:
#   /reaction/production/ios/asc-key-id       … キー ID
#   /reaction/production/ios/asc-issuer-id    … Issuer ID
#   /reaction/production/ios/asc-private-key  … AuthKey_XXXX.p8 の中身
#
# 使い方:
#   exports="$(scripts/appstore-connect.sh pull)" && eval "$exports"
#       .p8 を一時ディレクトリに AuthKey_<KEYID>.p8 として復元し、
#       altool が読む API_PRIVATE_KEYS_DIR / ASC_KEY_ID / ASC_ISSUER_ID の
#       export 文を標準出力に出す。
#       eval "$(... pull)" と直接書くと pull の失敗を検知できないので、
#       必ずコマンド置換の終了コードを先に確認すること。
#   scripts/appstore-connect.sh push <AuthKey_XXXX.p8>
#       手元の .p8 を SSM に登録する。キー ID と Issuer ID は対話で入力。
#
# 事前に production のプロファイルで認証しておくこと。
set -euo pipefail

region="${AWS_REGION:-ap-northeast-1}"
prefix="/reaction/production/ios"
expected_account=852798039462

# push が使う秘密ファイルの置き場。EXIT trap から参照するのでグローバルにする。
# local にすると trap 実行時にはスコープ外になり、後始末できない。
secret_dir=""

cleanup_secret_dir() {
  if [ -n "$secret_dir" ]; then
    rm -rf "$secret_dir"
    secret_dir=""
  fi
}

usage() {
  echo "usage: $0 pull [dir]" >&2
  echo "         exports=\"\$($0 pull)\" && eval \"\$exports\"" >&2
  echo "       $0 push <AuthKey_XXXX.p8>" >&2
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

get_param() {
  aws ssm get-parameter --region "$region" --with-decryption \
    --name "$1" --query 'Parameter.Value' --output text
}

# 秘密値はコマンドライン引数に載せない（ps や履歴から見えるため）。
# 権限 600 のファイル経由で渡す。
put_param_file() {
  aws ssm put-parameter --region "$region" --type SecureString --overwrite \
    --name "$1" --value "file://$2" >/dev/null
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
  local key_id issuer_id private_key

  # 標準出力に何か出す前に 3 値をすべて取得し、個別に成否を確認する。
  # コマンド置換を他コマンドの引数に埋めると set -e では失敗を検知できない。
  key_id="$(get_param "$prefix/asc-key-id")" || return 1
  issuer_id="$(get_param "$prefix/asc-issuer-id")" || return 1
  private_key="$(get_param "$prefix/asc-private-key")" || return 1

  mkdir -p "$dir"
  chmod 700 "$dir"

  # altool は API_PRIVATE_KEYS_DIR から AuthKey_<KEYID>.p8 を探す。
  # 最初から mode 600 の一時ファイルへ書き、成功したときだけ本来の名前へ
  # 置き換える。> で直接作ると umask 次第で他ユーザーから読める権限になる。
  local key_file tmp_key
  key_file="$dir/AuthKey_${key_id}.p8"
  tmp_key="$(mktemp "$dir/.AuthKey.XXXXXX")" || return 1
  if ! printf '%s\n' "$private_key" > "$tmp_key"; then
    rm -f "$tmp_key"
    return 1
  fi
  chmod 600 "$tmp_key"
  mv "$tmp_key" "$key_file" || { rm -f "$tmp_key"; return 1; }

  emit_export API_PRIVATE_KEYS_DIR "$dir"
  emit_export ASC_KEY_ID "$key_id"
  emit_export ASC_ISSUER_ID "$issuer_id"
}

do_push() {
  local key_path="$1"
  [ -f "$key_path" ] || { echo "missing: $key_path" >&2; exit 1; }

  # 秘密値はコマンドライン引数に載せず、権限 700 のディレクトリ配下の
  # ファイル経由で AWS CLI に渡す。
  secret_dir="$(mktemp -d)"
  chmod 700 "$secret_dir"
  # 後始末は EXIT だけに担当させ、INT / TERM ではハンドラから明示的に
  # 非 0 で終了する。同じ削除処理を INT / TERM に登録すると、bash は
  # ハンドラ実行後に処理を再開してしまい、中断したのに成功扱いになる。
  trap cleanup_secret_dir EXIT
  trap 'exit 130' INT
  trap 'exit 143' TERM

  local key_id issuer_id
  # ファイル名が AuthKey_XXXX.p8 ならキー ID を既定値にする
  local guessed
  guessed="$(basename "$key_path" .p8)"
  guessed="${guessed#AuthKey_}"
  read -rp "キー ID [${guessed}]: " key_id
  key_id="${key_id:-$guessed}"
  read -rp "Issuer ID: " issuer_id

  if [ -z "$key_id" ] || [ -z "$issuer_id" ]; then
    echo "error: キー ID と Issuer ID は必須です" >&2
    exit 1
  fi

  # 登録前に鍵として読めるか確認する。壊れた値を入れても
  # アップロード時まで気づけないため。
  if ! openssl pkey -in "$key_path" -noout >/dev/null 2>&1; then
    echo "error: $key_path を秘密鍵として読めません" >&2
    exit 1
  fi

  (umask 077; printf '%s' "$key_id" > "$secret_dir/key-id")
  (umask 077; printf '%s' "$issuer_id" > "$secret_dir/issuer-id")

  put_param_file "$prefix/asc-key-id" "$secret_dir/key-id"
  put_param_file "$prefix/asc-issuer-id" "$secret_dir/issuer-id"
  put_param_file "$prefix/asc-private-key" "$key_path"

  # 正常終了時は明示的に消す。bash 3.2 (macOS 標準) は、パイプなどの
  # サブシェルが正常終了したとき EXIT trap を発火しないため、
  # trap だけに任せると秘密値が残ることがある。
  cleanup_secret_dir
  trap - EXIT INT TERM

  echo "pushed $prefix/{asc-key-id,asc-issuer-id,asc-private-key}"
  echo
  echo "ダウンロードした .p8 は SSM に入ったので、手元から消して構いません:"
  echo "  rm $key_path"
}

action="${1:-}"
case "$action" in
  pull) require_production_account; do_pull "${2:-}" ;;
  push) [ $# -ge 2 ] || usage; require_production_account; do_push "$2" ;;
  *) usage ;;
esac
