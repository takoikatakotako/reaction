'use client';

import React, { useEffect, useState } from 'react';
import Link from 'next/link';
import Image from 'next/image';
import * as service from '@/lib/service';
import * as entity from '@/lib/entity';

export default function QuestionPage() {
  const [questions, setQuestions] = useState<entity.Question[]>([]);

  useEffect(() => {
    const loadQuestions = async () => {
      try {
        const questions = await service.fetchQuestions();
        setQuestions(questions);
      } catch (error) {
        alert(`エラーが発生しました:\n${error}`);
      }
    };

    loadQuestions();
  }, []);

  return (
    <main className="wrapper">
      <h1>学習問題一覧</h1>

      <div>
        <ul className="pagination">
          <Link href="/question/new">
            <li className="pagination-active">
              <p>追加</p>
            </li>
          </Link>
        </ul>
      </div>

      {questions.map((question) => (
        <div className="reaction-content" key={question.id}>
          <Link href={`/question/edit?id=${question.id}`}>
            <h2>ID: {question.id}</h2>
          </Link>
          {question.problemImageUrls.length > 0 && (
            <Image
              src={question.problemImageUrls[0]}
              loading="lazy"
              width={0}
              height={0}
              alt=""
            />
          )}
          <hr />
        </div>
      ))}
    </main>
  );
}
