import { beforeEach, describe, expect, it, vi } from 'vitest';

vi.stubEnv('NEXT_PUBLIC_API_KEY', 'test-api-key');
vi.stubEnv('NEXT_PUBLIC_API_BASE_URL', 'https://api.example.com');
vi.stubEnv(
  'NEXT_PUBLIC_RESOURCE_BASE_URL',
  'https://cdn.example.com/resource/image'
);

// 環境変数はモジュール読み込み時に評価されるので stubEnv の後に import する
const repository = await import('@/lib/repository');

const fetchMock = vi.fn();

function jsonResponse(body: unknown, ok = true): Response {
  return {
    ok,
    json: async () => body,
  } as Response;
}

beforeEach(() => {
  fetchMock.mockReset();
  vi.stubGlobal('fetch', fetchMock);
});

describe('fetchReactions', () => {
  it('一覧 API を叩いて reactions 配列を返す', async () => {
    fetchMock.mockResolvedValue(
      jsonResponse({ reactions: [{ id: '1', englishName: 'Aldol' }] })
    );
    const reactions = await repository.fetchReactions();
    expect(fetchMock).toHaveBeenCalledWith(
      'https://api.example.com/api/reaction/list'
    );
    expect(reactions).toEqual([{ id: '1', englishName: 'Aldol' }]);
  });

  it('レスポンスが ok でなければ例外を投げる', async () => {
    fetchMock.mockResolvedValue(jsonResponse({}, false));
    await expect(repository.fetchReactions()).rejects.toThrow(
      '反応機構一覧の取得に失敗しました。'
    );
  });
});

describe('fetchQuestion', () => {
  it('id 付きの詳細 API を叩く', async () => {
    fetchMock.mockResolvedValue(jsonResponse({ id: 'q1', order: 1 }));
    const question = await repository.fetchQuestion('q1');
    expect(fetchMock).toHaveBeenCalledWith(
      'https://api.example.com/api/question/detail/q1'
    );
    expect(question).toEqual({ id: 'q1', order: 1 });
  });
});

describe('deleteReaction', () => {
  it('Authorization ヘッダー付きで DELETE する', async () => {
    fetchMock.mockResolvedValue(jsonResponse({}));
    await repository.deleteReaction('abc');
    const [url, init] = fetchMock.mock.calls[0];
    expect(url).toBe('https://api.example.com/api/reaction/delete');
    expect(init.method).toBe('DELETE');
    expect(init.headers.Authorization).toBe('Bearer test-api-key');
    expect(JSON.parse(init.body)).toEqual({ id: 'abc' });
  });

  it('失敗時は例外を投げる', async () => {
    fetchMock.mockResolvedValue(jsonResponse({}, false));
    await expect(repository.deleteReaction('abc')).rejects.toThrow(
      '反応機構の削除に失敗しました。'
    );
  });
});

describe('uploadImage', () => {
  const dataUrl = `data:image/png;base64,${Buffer.from('png-bytes').toString('base64')}`;

  it('アップロード URL を取得してから PUT し、CDN の URL を返す', async () => {
    fetchMock
      .mockResolvedValueOnce(
        jsonResponse({ uploadUrl: 'https://s3.example.com/presigned' })
      )
      .mockResolvedValueOnce({ ok: true } as Response);

    const url = await repository.uploadImage(dataUrl);

    // 1回目: presigned URL の取得
    const [generateUrl, generateInit] = fetchMock.mock.calls[0];
    expect(generateUrl).toBe('https://api.example.com/api/generate-upload-url');
    expect(generateInit.headers.Authorization).toBe('Bearer test-api-key');
    const imageName = JSON.parse(generateInit.body).imageName as string;
    expect(imageName).toMatch(/^[0-9a-f-]{36}\.png$/);

    // 2回目: S3 への PUT
    const [putUrl, putInit] = fetchMock.mock.calls[1];
    expect(putUrl).toBe('https://s3.example.com/presigned');
    expect(putInit.method).toBe('PUT');
    expect(putInit.headers['Content-Type']).toBe('image/png');
    expect(Buffer.from(putInit.body).toString()).toBe('png-bytes');

    expect(url).toBe(`https://cdn.example.com/resource/image/${imageName}`);
  });

  it('data URL 形式でなければ例外を投げる', async () => {
    fetchMock.mockResolvedValueOnce(
      jsonResponse({ uploadUrl: 'https://s3.example.com/presigned' })
    );
    await expect(repository.uploadImage('not-a-data-url')).rejects.toThrow(
      'サムネイル画像の変換に失敗しました。'
    );
  });

  it('PUT が失敗したら例外を投げる', async () => {
    fetchMock
      .mockResolvedValueOnce(
        jsonResponse({ uploadUrl: 'https://s3.example.com/presigned' })
      )
      .mockResolvedValueOnce({ ok: false } as Response);
    await expect(repository.uploadImage(dataUrl)).rejects.toThrow(
      'サムネイルのアップロードに失敗しました。'
    );
  });
});

describe('exportToS3', () => {
  it('Authorization ヘッダー付きで POST する', async () => {
    fetchMock.mockResolvedValue(jsonResponse({}));
    await repository.exportToS3();
    const [url, init] = fetchMock.mock.calls[0];
    expect(url).toBe('https://api.example.com/api/export/s3');
    expect(init.method).toBe('POST');
    expect(init.headers.Authorization).toBe('Bearer test-api-key');
  });
});
