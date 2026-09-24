import { describe, expect, it } from 'vitest';
import {
  formatPublishedAt,
  fromDateInputValue,
  toDateInputValue,
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
