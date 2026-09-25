#!/usr/bin/env bash
# Android の Play 用アップロード鍵を SSM Parameter Store と手元の間で出し入れする。
# rikako (takoikatakotako/rikako) の同名スクリプトを 1 アプリ構成向けに簡略化したもの。
#
# SSM がマスター。pull は手元で署名付きビルドを作るときに使う。
#
# パラメータ（すべて SecureString、production アカウント）:
#   /reaction/production/android/upload-keystore           … アップロード鍵の keystore（base64）
#   /reaction/production/android/upload-keystore-password  … keystore のパスワード
#   /reaction/production/android/upload-key-alias          … 鍵の alias
#   /reaction/production/android/upload-key-password       … 鍵のパスワード
#
# 使い方:
#   exports="$(scripts/android-signing.sh pull)" && eval "$exports"
#       keystore を一時ディレクトリに復元し、Gradle が読む
#       ANDROID_KEYSTORE_FILE / ANDROID_KEYSTORE_PASSWORD / ANDROID_KEY_ALIAS /
#       ANDROID_KEY_PASSWORD の export 文を標準出力に出す。
#       eval "$(... pull)" と直接書くと pull の失敗を検知できないので、
#       必ずコマンド置換の終了コードを先に確認すること。
#   scripts/android-signing.sh push <keystore.jks>
#       手元の keystore を SSM に登録する。パスワードと alias は対話で入力
#       （コマンドライン履歴に残さない）。
#
# 事前に production のプロファイルで認証しておくこと。
# CI では OIDC で assume したロールでそのまま動く。
set -euo pipefail

region="${AWS_REGION:-ap-northeast-1}"

# push が使う秘密ファイルの置き場。EXIT trap から参照するのでグローバルにする。
# local にすると trap 実行時にはスコープ外になり、後始末できない。
secret_dir=""

cleanup_secret_dir() {
  if [ -n "$secret_dir" ]; then
    rm -rf "$secret_dir"
    secret_dir=""
  fi
}
prefix="/reaction/production/android"
expected_account=852798039462

usage() {
  echo "usage: $0 pull [dir]" >&2
  echo "         exports=\"\$($0 pull)\" && eval \"\$exports\"" >&2
  echo "         ※ eval \"\$($0 pull)\" と直接書くと pull の失敗を検知できない" >&2
  echo "       $0 push <keystore.jks>" >&2
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

do_pull() {
  local dir="${1:-${RUNNER_TEMP:-$(mktemp -d)}}"
  local keystore="$dir/upload-keystore.jks"
  local keystore_base64 store_password key_alias key_password

  # 標準出力に何か出す前に 4 値をすべて取得し、個別に成否を確認する。
  # コマンド置換を他コマンドの引数に埋めると set -e では失敗を検知できない。
  # local value="$(...)" も local の成功で上書きされるため宣言と代入を分ける。
  keystore_base64="$(get_param "$prefix/upload-keystore")" || return 1
  store_password="$(get_param "$prefix/upload-keystore-password")" || return 1
  key_alias="$(get_param "$prefix/upload-key-alias")" || return 1
  key_password="$(get_param "$prefix/upload-key-password")" || return 1

  mkdir -p "$dir"
  # 最初から mode 600 の一時ファイルへデコードし、成功したときだけ本来の名前へ
  # 置き換える。> で直接作ると umask 次第で他ユーザーから読める権限になり、
  # デコード失敗時は chmod に到達せず中途半端な keystore が残る。
  local tmp_keystore
  tmp_keystore="$(mktemp "$dir/.upload-keystore.XXXXXX")" || return 1
  if ! printf '%s' "$keystore_base64" | base64 -d > "$tmp_keystore"; then
    rm -f "$tmp_keystore"
    return 1
  fi
  chmod 600 "$tmp_keystore"
  mv "$tmp_keystore" "$keystore" || { rm -f "$tmp_keystore"; return 1; }

  emit_export ANDROID_KEYSTORE_FILE "$keystore"
  emit_export ANDROID_KEYSTORE_PASSWORD "$store_password"
  emit_export ANDROID_KEY_ALIAS "$key_alias"
  emit_export ANDROID_KEY_PASSWORD "$key_password"
}

# eval される export 文を組み立てる。
# シングルクォートで囲むだけでは値に ' が含まれると壊れるため、
# ' を '\'' に置換してから囲む（シェルの標準的なエスケープ）。
emit_export() {
  local name="$1" value="$2" escaped
  escaped=$(printf '%s' "$value" | sed "s/'/'\\\\''/g")
  printf "export %s='%s'\n" "$name" "$escaped"
}

# keystore の形式を先頭バイトで判定する（keytool の出力はロケール依存のため）。
# JKS は 0xFEEDFEED、PKCS12 は ASN.1 SEQUENCE (0x30) で始まる。
is_jks_keystore() {
  [ "$(xxd -p -l 4 "$1" 2>/dev/null)" = "feedfeed" ]
}

# 鍵パスワードを検証する。
# PKCS12 は store と key のパスワードを分けられない形式で、keytool は -keypass を
# 無視する。そのため「一致しているか」を確認するのが唯一の正しい検証になる。
# JKS は分けられるので、秘密鍵の取り出しを伴う操作で実際に検証する。
#
# 検証用の出力も呼び出し元の secret_dir 配下に置き、trap は do_push の 1 個に
# まとめる（ここで trap を張ると呼び出し元のものを上書きしてしまうため）。
verify_key_password() {
  local keystore="$1" secret_dir="$2" key_alias="$3"

  if is_jks_keystore "$keystore"; then
    if ! keytool -importkeystore -noprompt \
        -srckeystore "$keystore" -srcstorepass:file "$secret_dir/store-password" \
        -srcalias "$key_alias" -srckeypass:file "$secret_dir/key-password" \
        -destkeystore "$secret_dir/verify.jks" \
        -deststorepass:file "$secret_dir/store-password" \
        -destkeypass:file "$secret_dir/store-password" \
        >/dev/null 2>&1; then
      echo "error: 鍵のパスワードが違います" >&2
      return 1
    fi
    return 0
  fi

  # PKCS12
  if ! cmp -s "$secret_dir/store-password" "$secret_dir/key-password"; then
    echo "error: この keystore は PKCS12 形式のため、鍵のパスワードは" >&2
    echo "       keystore のパスワードと同じである必要があります" >&2
    return 1
  fi
}

do_push() {
  local keystore="$1"
  [ -f "$keystore" ] || { echo "missing: $keystore" >&2; exit 1; }

  # 秘密値はコマンドライン引数に載せず、権限 700 のディレクトリ配下の
  # ファイル経由で keytool / AWS CLI に渡す。検証用の一時出力もここに置き、
  # 後始末はこの trap 1 個で保証する。
  secret_dir="$(mktemp -d)"
  chmod 700 "$secret_dir"
  # 後始末は EXIT だけに担当させ、INT / TERM ではハンドラから明示的に
  # 非 0 で終了する。同じ削除処理を INT / TERM に登録すると、bash は
  # ハンドラ実行後に処理を再開してしまい、中断したのに成功扱いになる。
  trap cleanup_secret_dir EXIT
  trap 'exit 130' INT
  trap 'exit 143' TERM

  local key_alias
  read -rsp "keystore のパスワード: " store_password_input; echo
  read -rp  "鍵の alias: " key_alias
  read -rsp "鍵のパスワード: " key_password_input; echo

  (umask 077; printf '%s' "$store_password_input" > "$secret_dir/store-password")
  (umask 077; printf '%s' "$key_password_input" > "$secret_dir/key-password")
  (umask 077; printf '%s' "$key_alias" > "$secret_dir/key-alias")
  unset store_password_input key_password_input

  # 登録前に keystore・alias・鍵パスワードを検証する
  if ! keytool -list -keystore "$keystore" \
      -storepass:file "$secret_dir/store-password" -alias "$key_alias" >/dev/null 2>&1; then
    echo "error: keystore を開けないか alias が見つかりません" >&2
    exit 1
  fi
  verify_key_password "$keystore" "$secret_dir" "$key_alias" || exit 1

  (umask 077; base64 -i "$keystore" > "$secret_dir/keystore-base64")

  put_param_file "$prefix/upload-keystore" "$secret_dir/keystore-base64"
  put_param_file "$prefix/upload-keystore-password" "$secret_dir/store-password"
  put_param_file "$prefix/upload-key-alias" "$secret_dir/key-alias"
  put_param_file "$prefix/upload-key-password" "$secret_dir/key-password"

  # 正常終了時は明示的に消す。bash 3.2 (macOS 標準) は、パイプなどの
  # サブシェルが正常終了したとき EXIT trap を発火しないため、
  # trap だけに任せると秘密値が残ることがある。
  cleanup_secret_dir
  trap - EXIT INT TERM

  echo "pushed $prefix/{upload-keystore,upload-keystore-password,upload-key-alias,upload-key-password}"
}

action="${1:-}"
case "$action" in
  pull) require_production_account; do_pull "${2:-}" ;;
  push) [ $# -ge 2 ] || usage; require_production_account; do_push "$2" ;;
  *) usage ;;
esac
