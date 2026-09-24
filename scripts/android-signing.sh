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
#   eval "$(scripts/android-signing.sh pull)"
#       keystore を一時ディレクトリに復元し、Gradle が読む
#       ANDROID_KEYSTORE_FILE / ANDROID_KEYSTORE_PASSWORD / ANDROID_KEY_ALIAS /
#       ANDROID_KEY_PASSWORD の export 文を標準出力に出す。
#   scripts/android-signing.sh push <keystore.jks>
#       手元の keystore を SSM に登録する。パスワードと alias は対話で入力
#       （コマンドライン履歴に残さない）。
#
# 事前に production のプロファイルで認証しておくこと。
# CI では OIDC で assume したロールでそのまま動く。
set -euo pipefail

region="${AWS_REGION:-ap-northeast-1}"
prefix="/reaction/production/android"
expected_account=852798039462

usage() {
  echo "usage: $0 pull [dir]        # eval \"\$($0 pull)\" で環境変数に取り込む" >&2
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

put_param() {
  aws ssm put-parameter --region "$region" --type SecureString --overwrite \
    --name "$1" --value "$2" >/dev/null
}

do_pull() {
  local dir="${1:-${RUNNER_TEMP:-$(mktemp -d)}}"
  mkdir -p "$dir"
  local keystore="$dir/upload-keystore.jks"
  get_param "$prefix/upload-keystore" | base64 -d > "$keystore"
  chmod 600 "$keystore"
  emit_export ANDROID_KEYSTORE_FILE "$keystore"
  emit_export ANDROID_KEYSTORE_PASSWORD "$(get_param "$prefix/upload-keystore-password")"
  emit_export ANDROID_KEY_ALIAS "$(get_param "$prefix/upload-key-alias")"
  emit_export ANDROID_KEY_PASSWORD "$(get_param "$prefix/upload-key-password")"
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
verify_key_password() {
  local keystore="$1" store_password="$2" key_alias="$3" key_password="$4"

  if is_jks_keystore "$keystore"; then
    local dest
    dest="$(mktemp -u)"
    if ! keytool -importkeystore -noprompt \
        -srckeystore "$keystore" -srcstorepass "$store_password" \
        -srcalias "$key_alias" -srckeypass "$key_password" \
        -destkeystore "$dest" -deststorepass "verify-only" -destkeypass "verify-only" \
        >/dev/null 2>&1; then
      rm -f "$dest"
      echo "error: 鍵のパスワードが違います" >&2
      exit 1
    fi
    rm -f "$dest"
    return
  fi

  # PKCS12
  if [ "$key_password" != "$store_password" ]; then
    echo "error: この keystore は PKCS12 形式のため、鍵のパスワードは" >&2
    echo "       keystore のパスワードと同じである必要があります" >&2
    exit 1
  fi
}

do_push() {
  local keystore="$1"
  [ -f "$keystore" ] || { echo "missing: $keystore" >&2; exit 1; }

  local store_password key_alias key_password
  read -rsp "keystore のパスワード: " store_password; echo
  read -rp  "鍵の alias: " key_alias
  read -rsp "鍵のパスワード: " key_password; echo

  # 登録前に keystore・alias・鍵パスワードを検証する。
  # keytool -list は storepass と alias しか見ないため、鍵パスワードは別途確認する。
  if ! keytool -list -keystore "$keystore" -storepass "$store_password" -alias "$key_alias" >/dev/null 2>&1; then
    echo "error: keystore を開けないか alias が見つかりません" >&2
    exit 1
  fi
  verify_key_password "$keystore" "$store_password" "$key_alias" "$key_password"

  local tmp
  tmp="$(mktemp)"
  trap 'rm -f "$tmp"' EXIT
  base64 -i "$keystore" > "$tmp"
  put_param "$prefix/upload-keystore" "file://$tmp"
  put_param "$prefix/upload-keystore-password" "$store_password"
  put_param "$prefix/upload-key-alias" "$key_alias"
  put_param "$prefix/upload-key-password" "$key_password"
  echo "pushed $prefix/{upload-keystore,upload-keystore-password,upload-key-alias,upload-key-password}"
}

action="${1:-}"
case "$action" in
  pull) require_production_account; do_pull "${2:-}" ;;
  push) [ $# -ge 2 ] || usage; require_production_account; do_push "$2" ;;
  *) usage ;;
esac
