'use client';

import React, { useEffect, useState } from 'react';
import { useSearchParams, useRouter } from 'next/navigation';
import TextInputField from '../../reaction/common/TextInputField';
import TextAreaInputField from '../../reaction/common/TextAreaInputField';
import * as service from '@/lib/service';
import * as entity from '@/lib/entity';
import { fromDateInputValue, toDateInputValue } from '@/lib/notice';

export default function EditNotice() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const id = searchParams.get('id') ?? '';

  const [japaneseTitle, setJapaneseTitle] = useState<string>('');
  const [englishTitle, setEnglishTitle] = useState<string>('');
  const [japaneseBody, setJapaneseBody] = useState<string>('');
  const [englishBody, setEnglishBody] = useState<string>('');
  const [publishedDate, setPublishedDate] = useState<string>('');

  useEffect(() => {
    if (!id) return;
    const loadNotice = async () => {
      try {
        const notice: entity.Notice = await service.fetchNotice(id);
        setJapaneseTitle(notice.japaneseTitle);
        setEnglishTitle(notice.englishTitle);
        setJapaneseBody(notice.japaneseBody);
        setEnglishBody(notice.englishBody);
        setPublishedDate(toDateInputValue(notice.publishedAt));
      } catch (error) {
        alert(`エラーが発生しました:\n${error}`);
      }
    };

    loadNotice();
  }, [id]);

  const onEditSubmit = async () => {
    try {
      const editNotice: entity.EditNotice = {
        id: id,
        englishTitle: englishTitle,
        japaneseTitle: japaneseTitle,
        englishBody: englishBody,
        japaneseBody: japaneseBody,
        publishedAt: fromDateInputValue(publishedDate),
      };

      await service.editNotice(editNotice);
      alert('更新成功！');
      router.push('/notice');
    } catch (error) {
      alert(`エラーが発生しました:\n${error}`);
    }
  };

  const onDeleteSubmit = async () => {
    try {
      await service.deleteNotice(id);
      alert('削除成功！');
      router.push('/notice');
    } catch (error) {
      alert(`エラーが発生しました:\n${error}`);
    }
  };

  return (
    <main className="wrapper">
      <h1>お知らせ編集</h1>

      <form>
        <div className="reaction-edit-content">
          <label htmlFor="publishedDate">公開日</label>
          <input
            type="date"
            name="publishedDate"
            value={publishedDate}
            onChange={(e) => setPublishedDate(e.target.value)}
          />
          <hr />
        </div>

        <TextInputField
          label="タイトル(日本語)"
          name="japaneseTitle"
          value={japaneseTitle}
          onChange={(e) => setJapaneseTitle(e.target.value)}
        />

        <TextAreaInputField
          label="本文(日本語)"
          name="japaneseBody"
          value={japaneseBody}
          onChange={(e) => setJapaneseBody(e.target.value)}
        />

        <TextInputField
          label="タイトル(英語)"
          name="englishTitle"
          value={englishTitle}
          onChange={(e) => setEnglishTitle(e.target.value)}
        />

        <TextAreaInputField
          label="本文(英語)"
          name="englishBody"
          value={englishBody}
          onChange={(e) => setEnglishBody(e.target.value)}
        />

        <button
          type="button"
          className="reaction-edit-add-reaction-button"
          onClick={() => onEditSubmit()}
        >
          <div
            style={{
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              backgroundColor: '#007bff',
              color: 'white',
              padding: '15px 30px',
              borderRadius: '5px',
              fontSize: '16px',
              fontWeight: 'bold',
            }}
          >
            更新
          </div>
        </button>

        <button
          type="button"
          className="reaction-edit-add-reaction-button"
          onClick={() => onDeleteSubmit()}
        >
          <div
            style={{
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              backgroundColor: '#443322',
              color: 'white',
              padding: '15px 60px',
              borderRadius: '5px',
              fontSize: '16px',
              fontWeight: 'bold',
            }}
          >
            削除
          </div>
        </button>
      </form>
    </main>
  );
}
