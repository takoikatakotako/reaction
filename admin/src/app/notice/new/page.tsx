'use client';

import React, { useState } from 'react';
import { useRouter } from 'next/navigation';
import TextInputField from '../../reaction/common/TextInputField';
import TextAreaInputField from '../../reaction/common/TextAreaInputField';
import * as service from '@/lib/service';
import * as entity from '@/lib/entity';
import {
  ALL_NOTICE_LANGUAGES,
  ALL_NOTICE_PLATFORMS,
  fromDateInputValue,
  todayDateInputValue,
} from '@/lib/notice';
import NoticeTargetFields from '../common/NoticeTargetFields';

export default function NewNoticePage() {
  const router = useRouter();

  const [japaneseTitle, setJapaneseTitle] = useState<string>('');
  const [englishTitle, setEnglishTitle] = useState<string>('');
  const [japaneseBody, setJapaneseBody] = useState<string>('');
  const [englishBody, setEnglishBody] = useState<string>('');
  // 既定はすべての OS・言語
  const [platforms, setPlatforms] =
    useState<entity.NoticePlatform[]>(ALL_NOTICE_PLATFORMS);
  const [languages, setLanguages] =
    useState<entity.NoticeLanguage[]>(ALL_NOTICE_LANGUAGES);
  // 既定は今日（ブラウザのローカル日付基準）
  const [publishedDate, setPublishedDate] = useState<string>(
    todayDateInputValue()
  );

  const submitHandleChange = async () => {
    try {
      const addNotice: entity.AddNotice = {
        englishTitle: englishTitle,
        japaneseTitle: japaneseTitle,
        englishBody: englishBody,
        japaneseBody: japaneseBody,
        platforms: platforms,
        languages: languages,
        publishedAt: fromDateInputValue(publishedDate),
      };

      await service.addNotice(addNotice);
      alert('送信成功！');
      router.push('/notice');
    } catch (error) {
      alert(`エラーが発生しました:\n${error}`);
    }
  };

  return (
    <main className="wrapper">
      <h1>お知らせ追加</h1>

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

        <NoticeTargetFields
          platforms={platforms}
          languages={languages}
          onPlatformsChange={setPlatforms}
          onLanguagesChange={setLanguages}
        />

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
          onClick={() => submitHandleChange()}
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
            追加
          </div>
        </button>
      </form>
    </main>
  );
}
