'use client';

import React, { useEffect, useState } from 'react';
import Link from 'next/link';
import Image from 'next/image';
import * as service from '@/lib/service';
import * as entity from '@/lib/entity';

export default function ReactionPage() {
  const [reactions, setReactions] = useState<entity.Reaction[]>([]);

  useEffect(() => {
    const loadReaction = async () => {
      try {
        const reactions = await service.fetchReactions();
        setReactions(reactions);
      } catch (error) {
        alert(`エラーが発生しました:\n${error}`);
      }
    };

    loadReaction();
  }, []);

  return (
    <main className="wrapper">
      <h1>反応機構一覧</h1>

      <div>
        <ul className="pagination">
          <Link href="/reaction/new">
            <li className="pagination-active">
              <p>追加</p>
            </li>
          </Link>

          <Link href="/update">
            <li className="pagination-active">
              <p>更新</p>
            </li>
          </Link>
        </ul>
      </div>

      {reactions.map((reaction) => (
        <div className="reaction-content" key={reaction.id}>
          <Link href={`reaction/edit?id=${reaction.id}`}>
            <h2>ID: {reaction.id}</h2>
          </Link>
          <p>Name: {reaction.englishName}</p>
          <Image
            src={`${reaction.thumbnailImageUrl}`}
            loading="lazy"
            width={0}
            height={0}
            alt=""
          />
          <hr />
        </div>
      ))}
    </main>
  );
}
