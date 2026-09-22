import { describe, expect, it, vi } from 'vitest';
import * as service from '@/lib/service';
import * as repository from '@/lib/repository';
import type { AddReaction } from '@/lib/entity';

vi.mock('@/lib/repository');

const baseAddReaction: AddReaction = {
  englishName: 'Aldol Reaction',
  japaneseName: 'アルドール反応',
  thumbnailImageName: 'thumb.png',
  generalFormulaImageNames: [],
  mechanismsImageNames: [],
  exampleImageNames: [],
  supplementsImageNames: [],
  suggestions: [],
  reactants: [],
  products: [],
  youtubeUrls: [],
};

describe('extractImageName', () => {
  it('URL の末尾のファイル名を返す', () => {
    expect(
      service.extractImageName('https://cdn.example.com/resource/image/abc.png')
    ).toBe('abc.png');
  });

  it('クエリやフラグメントを含んでも除去する', () => {
    expect(
      service.extractImageName('https://cdn.example.com/a/b.png?v=1#top')
    ).toBe('b.png');
  });
});

describe('extractImageNames', () => {
  it('複数の URL をまとめてファイル名に変換する', () => {
    expect(
      service.extractImageNames([
        'https://cdn.example.com/1.png',
        'https://cdn.example.com/dir/2.png',
      ])
    ).toEqual(['1.png', '2.png']);
  });
});

describe('addReaction', () => {
  it('英語名が空なら例外を投げ、repository を呼ばない', async () => {
    await expect(
      service.addReaction({ ...baseAddReaction, englishName: '' })
    ).rejects.toThrow('英語名が入力されていません');
    expect(repository.addReaction).not.toHaveBeenCalled();
  });

  it('日本語名が空なら例外を投げ、repository を呼ばない', async () => {
    await expect(
      service.addReaction({ ...baseAddReaction, japaneseName: '' })
    ).rejects.toThrow('日本語名が入力されていません');
    expect(repository.addReaction).not.toHaveBeenCalled();
  });

  it('バリデーションを通れば repository.addReaction を呼ぶ', async () => {
    await service.addReaction(baseAddReaction);
    expect(repository.addReaction).toHaveBeenCalledWith(baseAddReaction);
  });
});

describe('テキスト配列のハンドラ', () => {
  it('handleTextsChange は指定 index の値だけを更新する', () => {
    const setTexts = vi.fn();
    const e = {
      target: { value: 'new' },
    } as React.ChangeEvent<HTMLInputElement>;
    service.handleTextsChange(e, 1, setTexts, ['a', 'b', 'c']);
    expect(setTexts).toHaveBeenCalledWith(['a', 'new', 'c']);
  });

  it('handleTextDelete は指定 index を取り除く', () => {
    const setTexts = vi.fn();
    service.handleTextDelete(0, setTexts);
    const updater = setTexts.mock.calls[0][0] as (prev: string[]) => string[];
    expect(updater(['a', 'b'])).toEqual(['b']);
  });

  it('handleTextsAdd は末尾に空文字を追加する', () => {
    const setTexts = vi.fn();
    service.handleTextsAdd(setTexts, ['a']);
    expect(setTexts).toHaveBeenCalledWith(['a', '']);
  });
});

describe('画像配列のハンドラ', () => {
  it('handleImagesDelete は指定 index を取り除く', () => {
    const setImageURLs = vi.fn();
    service.handleImagesDelete(1, setImageURLs);
    const updater = setImageURLs.mock.calls[0][0] as (
      prev: string[]
    ) => string[];
    expect(updater(['x', 'y', 'z'])).toEqual(['x', 'z']);
  });

  it('handleImageDelete は空文字にリセットする', () => {
    const setImageURL = vi.fn();
    service.handleImageDelete(setImageURL);
    expect(setImageURL).toHaveBeenCalledWith('');
  });
});

describe('選択肢配列のハンドラ', () => {
  it('handleSelectionAdd は末尾に空文字を追加する', () => {
    const set = vi.fn();
    service.handleSelectionAdd(set, ['Alcohol']);
    expect(set).toHaveBeenCalledWith(['Alcohol', '']);
  });

  it('handleSelectionDelete は指定 index を取り除く', () => {
    const set = vi.fn();
    service.handleSelectionDelete(0, set);
    const updater = set.mock.calls[0][0] as (prev: string[]) => string[];
    expect(updater(['a', 'b'])).toEqual(['b']);
  });
});
