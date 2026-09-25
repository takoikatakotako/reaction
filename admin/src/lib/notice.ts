// API から来る publishedAt は RFC3339 (UTC)。
// 画面では日付だけを扱うため、input[type=date] の値との相互変換を用意する。

export function toDateInputValue(publishedAt: string): string {
  if (!publishedAt) {
    return '';
  }
  const date = new Date(publishedAt);
  if (Number.isNaN(date.getTime())) {
    return '';
  }
  return date.toISOString().slice(0, 10);
}

export function fromDateInputValue(value: string): string {
  if (!value) {
    return '';
  }
  return `${value}T00:00:00Z`;
}

export function formatPublishedAt(publishedAt: string): string {
  const value = toDateInputValue(publishedAt);
  return value || '(公開日なし)';
}

/**
 * 今日の日付を input[type=date] 用の YYYY-MM-DD で返す。
 * toISOString() は UTC 基準のため、JST の 0:00〜8:59 に呼ぶと前日になる。
 * ブラウザのローカル年月日から組み立てる。
 */
export function todayDateInputValue(now: Date = new Date()): string {
  const year = now.getFullYear();
  const month = String(now.getMonth() + 1).padStart(2, '0');
  const day = String(now.getDate()).padStart(2, '0');
  return `${year}-${month}-${day}`;
}
