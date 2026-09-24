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
  it('ローカル日付を YYYY-MM-DD で返す', () => {
    // 2026-09-24 09:00 JST = 2026-09-24T00:00:00Z
    const jstMorning = new Date('2026-09-24T09:00:00+09:00');
    expect(todayDateInputValue(jstMorning)).toBe('2026-09-24');
  });

  it('JST の早朝でも UTC 基準で前日にならない', () => {
    // 2026-09-24 01:00 JST = 2026-09-23T16:00:00Z
    // toISOString() を使うと 2026-09-23 になってしまうケース
    const jstEarlyMorning = new Date('2026-09-24T01:00:00+09:00');
    expect(todayDateInputValue(jstEarlyMorning)).toBe('2026-09-24');
  });

  it('月日が 1 桁でもゼロ埋めする', () => {
    const date = new Date('2026-01-05T12:00:00+09:00');
    expect(todayDateInputValue(date)).toBe('2026-01-05');
  });
});
