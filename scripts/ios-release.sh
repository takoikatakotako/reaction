#!/usr/bin/env bash
# iOS のビルドを作って TestFlight にアップロードする。
#
# Firebase の設定取得・archive・export・検証・アップロードまで通しで行う。
# 終わると TestFlight に上がっている。
#
# 使い方:
#   AWS_PROFILE=reaction-production scripts/ios-release.sh production
#   AWS_PROFILE=reaction-production scripts/ios-release.sh development
#
#   RETRY=1 ...            同じコミットで作り直すとき（0-99）
#   SKIP_UPLOAD=1 ...      ipa を作るところまでで止める
#
# App Store Connect の API キーは SSM がマスター。
# 未登録なら scripts/appstore-connect.sh push で入れること。
#
# development の Firebase 設定は development アカウントにあるため、
# その取得だけは AWS_PROFILE=reaction-development で別途行う
# （このスクリプトは既にある plist を使い、無ければ案内して止まる）。
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$repo_root"

target="${1:-}"
case "$target" in
  production)
    scheme_suffix=""
    plist="ios/Config/Production/GoogleService-Info.plist"
    plist_hint="AWS_PROFILE=reaction-production ./scripts/firebase-config.sh pull ios prod"
    ipa="ios/build/export/ReactionProduction.ipa"
    ;;
  development)
    scheme_suffix="-development"
    plist="ios/Config/Development/GoogleService-Info.plist"
    plist_hint="AWS_PROFILE=reaction-development ./scripts/firebase-config.sh pull ios dev"
    ipa="ios/build/export-development/ReactionDevelopment.ipa"
    ;;
  *)
    echo "usage: $0 <production|development>" >&2
    exit 2
    ;;
esac

# Firebase の設定が無いとビルドは通るが実行時に Crashlytics が動かない。
# アップロードしてから気づくと配り直しになるので、先に止める。
if [ ! -f "$plist" ]; then
  echo "error: $plist がありません" >&2
  echo "       $plist_hint" >&2
  exit 1
fi

# アップロードしない場合は AWS に触れる必要がない
asc_dir=""
cleanup_asc_dir() {
  if [ -n "$asc_dir" ]; then
    rm -rf "$asc_dir"
    asc_dir=""
  fi
}

if [ -z "${SKIP_UPLOAD:-}" ]; then
  echo "==> App Store Connect の API キーを取得"
  asc_dir="$(mktemp -d)"
  trap cleanup_asc_dir EXIT
  trap 'exit 130' INT
  trap 'exit 143' TERM
  # eval "$(...)" と直接書くと pull の失敗を検知できないので、
  # コマンド置換の終了コードを先に確認する。
  asc_exports="$(./scripts/appstore-connect.sh pull "$asc_dir")"
  eval "$asc_exports"
fi

echo "==> archive${scheme_suffix}"
make -C ios "archive${scheme_suffix}"

echo "==> export${scheme_suffix}"
make -C ios "export${scheme_suffix}"

[ -f "$ipa" ] || { echo "error: $ipa が生成されていません" >&2; exit 1; }

build_number="$(make -C ios --no-print-directory print-build-number)"
marketing_version="$(make -C ios --no-print-directory print-marketing-version)"
echo
echo "できました: $ipa"
echo "  バージョン:   $marketing_version ($build_number)"
echo "  コミット:     $(git rev-parse --short HEAD)"

if [ -n "${SKIP_UPLOAD:-}" ]; then
  echo
  echo "SKIP_UPLOAD が指定されているのでアップロードしません。"
  exit 0
fi

# 先に検証してからアップロードする。アップロードは取り消せないので、
# 弾かれる理由が分かっているなら手前で止めたい。
echo
echo "==> 検証"
xcrun altool --validate-app -f "$ipa" -t ios \
  --apiKey "$ASC_KEY_ID" --apiIssuer "$ASC_ISSUER_ID"

echo
echo "==> アップロード"
xcrun altool --upload-app -f "$ipa" -t ios \
  --apiKey "$ASC_KEY_ID" --apiIssuer "$ASC_ISSUER_ID"

cleanup_asc_dir
trap - EXIT INT TERM

echo
echo "アップロードしました。App Store Connect の TestFlight に出るまで 5-15 分かかります。"
