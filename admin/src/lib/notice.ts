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
