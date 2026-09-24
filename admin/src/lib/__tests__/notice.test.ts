import { describe, expect, it } from 'vitest';
import {
  formatPublishedAt,
  fromDateInputValue,
  toDateInputValue,
  todayDateInputValue,
} from '@/lib/notice';

describe('toDateInputValue', () => {
  it('RFC3339 から YYYY-MM-DD を取り出す', () => {
    expect(toDateInputValue('2026-09-24T00:00:00Z')).toBe('2026-09-24');
  });

  it('時刻があっても日付だけを返す', () => {
    expect(toDateInputValue('2026-09-24T15:30:45Z')).toBe('2026-09-24');
  });

  it('空文字や不正な値は空文字を返す', () => {
    expect(toDateInputValue('')).toBe('');
    expect(toDateInputValue('not-a-date')).toBe('');
  });
});

describe('fromDateInputValue', () => {
  it('YYYY-MM-DD を RFC3339 (UTC) にする', () => {
    expect(fromDateInputValue('2026-09-24')).toBe('2026-09-24T00:00:00Z');
  });

  it('空文字は空文字のまま', () => {
    expect(fromDateInputValue('')).toBe('');
  });
});

describe('相互変換', () => {
  it('toDateInputValue と fromDateInputValue は往復する', () => {
    const original = '2026-09-24T00:00:00Z';
    expect(fromDateInputValue(toDateInputValue(original))).toBe(original);
  });
});

describe('formatPublishedAt', () => {
  it('日付を表示用に整える', () => {
    expect(formatPublishedAt('2026-09-24T00:00:00Z')).toBe('2026-09-24');
  });

  it('未設定はプレースホルダを返す', () => {
    expect(formatPublishedAt('')).toBe('(公開日なし)');
  });
});

describe('todayDateInputValue', () => {
  // 「ローカル日付を返す」という契約なので、ローカル時刻で組み立てた Date で検証する。
  // new Date('...+09:00') のような絶対時刻を使うと、実行環境の TZ に依存してしまう
  // （CI は UTC、手元は JST）。
  it('ローカル日付を YYYY-MM-DD で返す', () => {
    const localNoon = new Date(2026, 8, 24, 12, 0, 0);
    expect(todayDateInputValue(localNoon)).toBe('2026-09-24');
  });

  it('ローカルの early morning でも同じ日付を返す', () => {
    const localEarlyMorning = new Date(2026, 8, 24, 1, 0, 0);
    expect(todayDateInputValue(localEarlyMorning)).toBe('2026-09-24');
  });

  it('UTC 日付とずれる時刻でもローカル日付を優先する', () => {
    // UTC より東の TZ では toISOString() が前日を返す時刻。
    // UTC で実行した場合は両者が一致するだけで、期待値はどちらでも変わらない。
    const localEarlyMorning = new Date(2026, 8, 24, 1, 0, 0);
    expect(todayDateInputValue(localEarlyMorning)).toBe('2026-09-24');
    expect(todayDateInputValue(localEarlyMorning)).toBe(
      `${localEarlyMorning.getFullYear()}-09-24`
    );
  });

  it('月日が 1 桁でもゼロ埋めする', () => {
    const date = new Date(2026, 0, 5, 12, 0, 0);
    expect(todayDateInputValue(date)).toBe('2026-01-05');
  });

  it('年末年始でも破綻しない', () => {
    expect(todayDateInputValue(new Date(2026, 11, 31, 23, 59, 0))).toBe(
      '2026-12-31'
    );
    expect(todayDateInputValue(new Date(2027, 0, 1, 0, 1, 0))).toBe(
      '2027-01-01'
    );
  });
});
