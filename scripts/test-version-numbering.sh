#!/usr/bin/env bash
# 配信番号の採番と RETRY のバリデーションを検証する。
#
# Android にだけ範囲チェックが入っていて iOS に無い、という抜けが
# レビューで 2 回見つかったので、両方まとめてテストする。
# AWS には触らない。
set -uo pipefail

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$repo_root"

fail=0

check() {
  local label="$1" expected="$2" actual="$3"
  if [ "$expected" = "$actual" ]; then
    printf 'ok   %s\n' "$label"
  else
    printf 'FAIL %s: expected=%s actual=%s\n' "$label" "$expected" "$actual"
    fail=1
  fi
}

count="$(git rev-list --count HEAD)"
echo "コミット数: $count"
echo

echo "--- Android: 採番"
for retry in 0 1 99; do
  actual="$(RETRY=$retry ./scripts/android-release.sh --print-version-code 2>/dev/null)"
  check "RETRY=$retry" "$(( count * 100 + retry ))" "$actual"
done

# 空文字は未指定として 0 に倒す（RETRY= と書かれた場合）
echo "--- 空文字は 0 として扱う"
check "Android RETRY=''" "$(( count * 100 ))" "$(RETRY= ./scripts/android-release.sh --print-version-code 2>/dev/null)"
check "iOS RETRY=''" "$(( count * 100 ))" "$(make -C ios -n archive RETRY= 2>/dev/null | sed -n 's/.*CURRENT_PROJECT_VERSION=\([0-9]*\).*/\1/p' | head -1)"

echo "--- Android: 不正値を弾く"
for retry in 100 -1 abc; do
  RETRY="$retry" ./scripts/android-release.sh --print-version-code >/dev/null 2>&1
  check "RETRY='$retry' が非ゼロ終了" "rejected" "$([ $? -ne 0 ] && echo rejected || echo accepted)"
done

echo "--- iOS: 採番"
for retry in 0 1 99; do
  # make -n はレシピを実行しないので、xcodebuild の行から番号を読む
  actual="$(make -C ios -n archive RETRY=$retry 2>/dev/null \
    | sed -n 's/.*CURRENT_PROJECT_VERSION=\([0-9]*\).*/\1/p' | head -1)"
  check "RETRY=$retry" "$(( count * 100 + retry ))" "$actual"
done

echo "--- iOS: 不正値を弾く"
for retry in 100 -1 abc; do
  make -C ios check-retry RETRY="$retry" >/dev/null 2>&1
  check "RETRY='$retry' が非ゼロ終了" "rejected" "$([ $? -ne 0 ] && echo rejected || echo accepted)"
done

echo
if [ "$fail" -ne 0 ]; then
  echo "失敗あり" >&2
  exit 1
fi
echo "すべて通過"
