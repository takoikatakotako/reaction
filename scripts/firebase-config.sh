#!/usr/bin/env bash
# Firebase のクライアント設定ファイルを SSM Parameter Store と手元の間で出し入れする。
# rikako (takoikatakotako/rikako) の同名スクリプトを 1 アプリ構成向けに簡略化したもの。
#
# これらは API キーを含むが秘密度は低い（アプリに同梱されて配布される値）。
# SSM に置くのは、置き場所を 1 箇所に決めて各自の手元に散らさないため。
#
# パラメータ（すべて SecureString、手動 put。Terraform 管理外）:
#   /reaction/development/firebase/ios       … GoogleService-Info.plist
#   /reaction/production/firebase/ios        … 同上
#   /reaction/production/firebase/android    … google-services.json
#
# Android は Firebase プロジェクトが本番のみのため production だけ。
#
# 使い方:
#   scripts/firebase-config.sh pull android
#   scripts/firebase-config.sh pull ios dev
#   scripts/firebase-config.sh pull ios prod
#   scripts/firebase-config.sh push android <google-services.json>
#
# 1 回の実行が触るのは 1 アカウントだけ。android と ios prod は production、
# ios dev は development にあるため、まとめて取得する all のような指定は
# 用意していない（1 つの資格情報では両方のアカウントを満たせない）。
#
# 事前に対象環境のプロファイルで認証しておくこと。
# CI は使わない。Android CI は android/ci/google-services.json（ダミー）で
# ビルドするので、PR のワークフローに AWS の認証情報は渡していない。
set -euo pipefail

region="${AWS_REGION:-ap-northeast-1}"
repo_root="$(cd "$(dirname "$0")/.." && pwd)"

dev_account=467988630030
prod_account=852798039462

usage() {
  echo "usage: $0 pull <android|ios> [dev|prod]" >&2
  echo "       $0 push android <google-services.json>" >&2
  exit 2
}

# 間違ったアカウントの同名パスを読み書きしないよう STS で検証する
require_account() {
  local expected="$1" actual
  actual="$(aws sts get-caller-identity --query Account --output text 2>/dev/null || true)"
  if [ "$actual" != "$expected" ]; then
    echo "error: AWS アカウント $expected が必要だが、現在の認証情報は ${actual:-取得失敗}" >&2
    exit 1
  fi
}

get_param() {
  aws ssm get-parameter --region "$region" --with-decryption \
    --name "$1" --query 'Parameter.Value' --output text
}

pull_android() {
  require_account "$prod_account"
  local dest="$repo_root/android/app/google-services.json"
  local value
  value="$(get_param /reaction/production/firebase/android)" || return 1
  mkdir -p "$(dirname "$dest")"
  printf '%s' "$value" > "$dest"
  echo "wrote android/app/google-services.json"
}

pull_ios() {
  local env="$1" account param dest
  case "$env" in
    dev)  account="$dev_account";  param=/reaction/development/firebase/ios; dest="$repo_root/ios/Config/Development/GoogleService-Info.plist" ;;
    prod) account="$prod_account"; param=/reaction/production/firebase/ios;  dest="$repo_root/ios/Config/Production/GoogleService-Info.plist" ;;
    *) usage ;;
  esac
  require_account "$account"
  local value
  value="$(get_param "$param")" || return 1
  mkdir -p "$(dirname "$dest")"
  printf '%s' "$value" > "$dest"
  echo "wrote ${dest#"$repo_root"/}"
}

push_android() {
  local src="$1"
  [ -f "$src" ] || { echo "missing: $src" >&2; exit 1; }
  require_account "$prod_account"
  aws ssm put-parameter --region "$region" --type SecureString --overwrite \
    --name /reaction/production/firebase/android --value "file://$src" >/dev/null
  echo "pushed /reaction/production/firebase/android"
}

action="${1:-}"
target="${2:-}"
case "$action" in
  pull)
    case "$target" in
      android) pull_android ;;
      ios)     pull_ios "${3:-dev}" ;;
      *) usage ;;
    esac
    ;;
  push)
    [ "$target" = "android" ] && [ $# -ge 3 ] || usage
    push_android "$3"
    ;;
  *) usage ;;
esac
