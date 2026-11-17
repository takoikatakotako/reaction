import type { NoticeLanguage, NoticePlatform } from '@/lib/entity';

export const NOTICE_PLATFORMS: { value: NoticePlatform; label: string }[] = [
  { value: 'ios', label: 'iOS' },
  { value: 'android', label: 'Android' },
];

export const NOTICE_LANGUAGES: { value: NoticeLanguage; label: string }[] = [
  { value: 'ja', label: '日本語' },
  { value: 'en', label: '英語' },
];

// 追加・編集画面の入力欄に出す記入例
export const NOTICE_PLACEHOLDERS = {
  japaneseTitle: '例: メンテナンスのお知らせ',
  japaneseBody:
    '例: いつもReactionをご利用いただきありがとうございます。\n\n〇月〇日にメンテナンスを行います。',
  englishTitle: 'e.g. Scheduled maintenance',
  englishBody:
    'e.g. Thank you for using Reaction.\n\nWe will perform maintenance on ...',
};

export const ALL_NOTICE_PLATFORMS: NoticePlatform[] = NOTICE_PLATFORMS.map(
  (p) => p.value
);
export const ALL_NOTICE_LANGUAGES: NoticeLanguage[] = NOTICE_LANGUAGES.map(
  (l) => l.value
);

/**
 * チェックボックスの ON/OFF を反映する。並び順は options の定義順にそろえる。
 */
export function toggleTarget<T extends string>(
  current: T[],
  value: T,
  checked: boolean,
  options: { value: T }[]
): T[] {
  const next = new Set(current);
  if (checked) {
    next.add(value);
  } else {
    next.delete(value);
  }
  return options.map((o) => o.value).filter((v) => next.has(v));
}

/**
 * 一覧表示用のラベル。例: "iOS / Android"
 */
export function formatTargets<T extends string>(
  values: T[] | undefined,
  options: { value: T; label: string }[]
): string {
  return options
    .filter((o) => values?.includes(o.value))
    .map((o) => o.label)
    .join(' / ');
}

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
