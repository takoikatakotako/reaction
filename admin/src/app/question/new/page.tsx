'use client';

import React, { useState, useRef } from 'react';
import { useRouter } from 'next/navigation';
import ImagesInputField from '../../reaction/common/ImagesInputField';
import TextsInputField from '../../reaction/common/TextsInputField';
import TextInputField from '../../reaction/common/TextInputField';
import * as service from '@/lib/service';
import * as entity from '@/lib/entity';
import {
  DEFAULT_QUESTION_ENGLISH_TITLE,
  DEFAULT_QUESTION_JAPANESE_TITLE,
  DIFFICULTY_OPTIONS,
} from '@/lib/constants';

export default function NewQuestionPage() {
  const router = useRouter();

  // Order
  const [order, setOrder] = useState<number>(0);

  // Title
  const [englishTitle, setEnglishTitle] = useState<string>(DEFAULT_QUESTION_ENGLISH_TITLE);
  const [japaneseTitle, setJapaneseTitle] = useState<string>(DEFAULT_QUESTION_JAPANESE_TITLE);

  // Category / Number / Difficulty
  const [category, setCategory] = useState<string>('');
  const [number, setNumber] = useState<number>(0);
  const [difficulty, setDifficulty] = useState<number>(1);

  // Problem Images
  const [problemImageURLs, setProblemImageURLs] = useState<string[]>([]);
  const problemInputRef = useRef<HTMLInputElement>(null);
  const onProblemChange = (e: React.ChangeEvent<HTMLInputElement>) =>
    service.handleImagesChange(e, setProblemImageURLs, problemImageURLs, problemInputRef);
  const onProblemDelete = (index: number) =>
    service.handleImagesDelete(index, setProblemImageURLs);

  // Solution Images
  const [solutionImageURLs, setSolutionImageURLs] = useState<string[]>([]);
  const solutionInputRef = useRef<HTMLInputElement>(null);
  const onSolutionChange = (e: React.ChangeEvent<HTMLInputElement>) =>
    service.handleImagesChange(e, setSolutionImageURLs, solutionImageURLs, solutionInputRef);
  const onSolutionDelete = (index: number) =>
    service.handleImagesDelete(index, setSolutionImageURLs);

  // References
  const [references, setReferences] = useState<string[]>([]);
  const onReferencesChange = (
    e: React.ChangeEvent<HTMLInputElement>,
    index: number
  ) => service.handleTextsChange(e, index, setReferences, references);
  const onReferencesDelete = (index: number) => {
    service.handleTextDelete(index, setReferences);
  };
  const onReferencesAdd = () => {
    service.handleTextsAdd(setReferences, references);
  };

  // Submit
  const submitHandleChange = async () => {
    try {
      const problemImageNames = service.extractImageNames(problemImageURLs);
      const solutionImageNames = service.extractImageNames(solutionImageURLs);

      const addQuestion: entity.AddQuestion = {
        order: order,
        englishTitle: englishTitle,
        japaneseTitle: japaneseTitle,
        category: category,
        number: number,
        difficulty: difficulty,
        problemImageNames: problemImageNames,
        solutionImageNames: solutionImageNames,
        references: references,
      };

      await service.addQuestion(addQuestion);
      alert('送信成功！');
      router.push('/question');
    } catch (error) {
      alert(`エラーが発生しました:\n${error}`);
    }
  };

  return (
    <main className="wrapper">
      <h1>学習問題追加</h1>

      <form>
        {/* Order */}
        <div className="reaction-edit-content">
          <label htmlFor="order">表示順</label>
          <input
            type="number"
            name="order"
            value={order}
            onChange={(e) => setOrder(Number(e.target.value))}
          />
          <hr />
        </div>

        {/* English Title */}
        <TextInputField
          label="タイトル(英語)"
          name="englishTitle"
          value={englishTitle}
          onChange={(e) => setEnglishTitle(e.target.value)}
        />

        {/* Japanese Title */}
        <TextInputField
          label="タイトル(日本語)"
          name="japaneseTitle"
          value={japaneseTitle}
          onChange={(e) => setJapaneseTitle(e.target.value)}
        />

        {/* Category */}
        <TextInputField
          label="カテゴリ"
          name="category"
          placeholder="例: 今週の反応機構"
          value={category}
          onChange={(e) => setCategory(e.target.value)}
        />

        {/* Number */}
        <div className="reaction-edit-content">
          <label htmlFor="number">問題番号</label>
          <input
            type="number"
            name="number"
            value={number}
            onChange={(e) => setNumber(Number(e.target.value))}
          />
          <hr />
        </div>

        {/* Difficulty */}
        <div className="reaction-edit-content">
          <label htmlFor="difficulty">難易度</label>
          <select
            name="difficulty"
            value={difficulty}
            onChange={(e) => setDifficulty(Number(e.target.value))}
          >
            {DIFFICULTY_OPTIONS.map((level) => (
              <option key={level} value={level}>
                {`Lv.${level}`}
              </option>
            ))}
          </select>
          <hr />
        </div>

        {/* Problem Images */}
        <ImagesInputField
          label="problemImages"
          name="問題画像"
          imageURLs={problemImageURLs}
          inputRef={problemInputRef}
          onImageChange={onProblemChange}
          onImageDelete={onProblemDelete}
        />

        {/* Solution Images */}
        <ImagesInputField
          label="solutionImages"
          name="解答画像"
          imageURLs={solutionImageURLs}
          inputRef={solutionInputRef}
          onImageChange={onSolutionChange}
          onImageDelete={onSolutionDelete}
        />

        {/* References */}
        <TextsInputField
          label="references"
          name="参考文献"
          texts={references}
          onTextsChange={onReferencesChange}
          onTextsDelete={onReferencesDelete}
          onTextsAdd={onReferencesAdd}
        />

        {/* Submit */}
        <button
          type="button"
          className="reaction-edit-add-reaction-button"
          onClick={() => submitHandleChange()}
        >
          <div style={{
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            backgroundColor: '#007bff',
            color: 'white',
            padding: '15px 30px',
            borderRadius: '5px',
            fontSize: '16px',
            fontWeight: 'bold',
          }}>
            追加
          </div>
        </button>
      </form>
    </main>
  );
}
