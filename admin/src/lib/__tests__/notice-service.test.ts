import { beforeEach, describe, expect, it, vi } from 'vitest';
import * as service from '@/lib/service';
import * as repository from '@/lib/repository';
import type { AddNotice } from '@/lib/entity';

vi.mock('@/lib/repository');

const baseNotice: AddNotice = {
  englishTitle: 'Maintenance',
  japaneseTitle: 'メンテナンスのお知らせ',
  englishBody: 'We will perform maintenance.',
  japaneseBody: 'メンテナンスを行います。',
  publishedAt: '2026-09-24T00:00:00Z',
};

beforeEach(() => {
  vi.clearAllMocks();
});

describe('addNotice', () => {
  it('日本語タイトルが空なら例外を投げ、repository を呼ばない', async () => {
    await expect(
      service.addNotice({ ...baseNotice, japaneseTitle: '' })
    ).rejects.toThrow('日本語のタイトルが入力されていません');
    expect(repository.addNotice).not.toHaveBeenCalled();
  });

  it('英語タイトルが空なら例外を投げる', async () => {
    await expect(
      service.addNotice({ ...baseNotice, englishTitle: '' })
    ).rejects.toThrow('英語のタイトルが入力されていません');
    expect(repository.addNotice).not.toHaveBeenCalled();
  });

  it('公開日が空なら例外を投げる', async () => {
    await expect(
      service.addNotice({ ...baseNotice, publishedAt: '' })
    ).rejects.toThrow('公開日が入力されていません');
    expect(repository.addNotice).not.toHaveBeenCalled();
  });

  it('バリデーションを通れば repository.addNotice を呼ぶ', async () => {
    await service.addNotice(baseNotice);
    expect(repository.addNotice).toHaveBeenCalledWith(baseNotice);
  });
});

describe('editNotice', () => {
  it('同じバリデーションが効く', async () => {
    await expect(
      service.editNotice({ ...baseNotice, id: 'abc', japaneseTitle: '' })
    ).rejects.toThrow('日本語のタイトルが入力されていません');
    expect(repository.editNotice).not.toHaveBeenCalled();
  });

  it('通れば repository.editNotice を呼ぶ', async () => {
    const edit = { ...baseNotice, id: 'abc' };
    await service.editNotice(edit);
    expect(repository.editNotice).toHaveBeenCalledWith(edit);
  });
});

describe('deleteNotice', () => {
  it('repository.deleteNotice に id を渡す', async () => {
    await service.deleteNotice('abc');
    expect(repository.deleteNotice).toHaveBeenCalledWith('abc');
  });
});
