#!/usr/bin/env bash
# Play にアップロードする署名付き AAB を手元で作る。
#
# 本番の Firebase 設定と Play のアップロード鍵を SSM から取得してからビルドし、
# 最後に AAB の署名がアップロード鍵と一致することを確認する。
#
# 事前に production のプロファイルで認証しておくこと:
#   AWS_PROFILE=reaction-production scripts/android-release.sh
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$repo_root"

# Play は同じ versionCode の再アップロードを受け付けない。コミット数から
# 採番する。単調増加で、どのコミットのビルドか後から辿れる。
# 同じコミットで作り直すときだけ ANDROID_VERSION_CODE で明示する。
if [ "$(git rev-parse --is-shallow-repository)" = "true" ]; then
  echo "error: 浅いクローンではビルド番号を採番できません" >&2
  echo "       git fetch --unshallow するか fetch-depth: 0 を指定してください" >&2
  exit 1
fi
export ANDROID_VERSION_CODE="${ANDROID_VERSION_CODE:-$(git rev-list --count HEAD)}"
echo "==> versionCode = $ANDROID_VERSION_CODE"

echo "==> Firebase 設定を取得"
./scripts/firebase-config.sh pull android

echo "==> アップロード鍵を取得"
# eval "$(...)" と直接書くと pull の失敗を検知できないので、
# コマンド置換の終了コードを先に確認する。
exports="$(./scripts/android-signing.sh pull)"
eval "$exports"

echo "==> bundleRelease"
(cd android && ./gradlew bundleRelease)

aab="android/app/build/outputs/bundle/release/app-release.aab"
[ -f "$aab" ] || { echo "error: $aab が生成されていません" >&2; exit 1; }

echo "==> 署名を検証"
# keystore 側と AAB 側の証明書フィンガープリントを突き合わせる。
# 鍵を取り違えると Play が受け付けないので、アップロード前にここで落とす。
key_sha="$(keytool -list -v -keystore "$ANDROID_KEYSTORE_FILE" \
  -storepass "$ANDROID_KEYSTORE_PASSWORD" -alias "$ANDROID_KEY_ALIAS" 2>/dev/null \
  | awk '/SHA256:/ {print $2; exit}')"

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT
unzip -oq "$aab" 'META-INF/*' -d "$work"
cert="$(find "$work/META-INF" -name '*.RSA' -o -name '*.DSA' -o -name '*.EC' | head -1)"
[ -n "$cert" ] || { echo "error: AAB に署名が見つかりません" >&2; exit 1; }
aab_sha="$(keytool -printcert -file "$cert" 2>/dev/null | awk '/SHA256:/ {print $2; exit}')"

if [ "$key_sha" != "$aab_sha" ]; then
  echo "error: 署名がアップロード鍵と一致しません" >&2
  echo "  keystore: $key_sha" >&2
  echo "  aab:      $aab_sha" >&2
  exit 1
fi

echo
echo "できました: $aab"
echo "  versionCode: $ANDROID_VERSION_CODE"
echo "  versionName: $(grep -E '^\s*versionName' android/app/build.gradle.kts | grep -oE '"[^"]+"' | tr -d '"')"
echo "  SHA256:      $aab_sha"
echo
echo "Play Console → テスト → 内部テスト → 新しいリリースを作成 からアップロードしてください。"
