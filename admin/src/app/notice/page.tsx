'use client';

import React, { useEffect, useState } from 'react';
import Link from 'next/link';
import * as service from '@/lib/service';
import * as entity from '@/lib/entity';
import {
  NOTICE_LANGUAGES,
  NOTICE_PLATFORMS,
  formatPublishedAt,
  formatTargets,
} from '@/lib/notice';

export default function NoticePage() {
  const [notices, setNotices] = useState<entity.Notice[]>([]);

  useEffect(() => {
    const loadNotices = async () => {
      try {
        const notices = await service.fetchNotices();
        setNotices(notices);
      } catch (error) {
        alert(`エラーが発生しました:\n${error}`);
      }
    };

    loadNotices();
  }, []);

  return (
    <main className="wrapper">
      <h1>お知らせ一覧</h1>

      <div>
        <ul className="pagination">
          <Link href="/notice/new">
            <li className="pagination-active">
              <p>追加</p>
            </li>
          </Link>
        </ul>
      </div>

      {notices.length === 0 && <p>お知らせはまだありません。</p>}

      {notices.map((notice) => (
        <div className="reaction-content" key={notice.id}>
          <Link href={`/notice/edit?id=${notice.id}`}>
            <h2>
              {formatPublishedAt(notice.publishedAt)} -{' '}
              {notice.japaneseTitle || notice.englishTitle}
            </h2>
          </Link>
          <p>
            対象OS: {formatTargets(notice.platforms, NOTICE_PLATFORMS)} ／
            対象言語: {formatTargets(notice.languages, NOTICE_LANGUAGES)}
          </p>
          <p>{notice.japaneseBody || notice.englishBody}</p>
          <hr />
        </div>
      ))}
    </main>
  );
}
