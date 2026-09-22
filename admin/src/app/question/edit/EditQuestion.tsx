'use client';

import React, { useState, useRef, useEffect } from 'react';
import { useSearchParams, useRouter } from 'next/navigation';
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

export default function EditQuestion() {
  const searchParams = useSearchParams();
  const id: string = searchParams.get('id') ?? '';
  const router = useRouter();

  // Order
  const [order, setOrder] = useState<number>(0);

  // Title
  const [englishTitle, setEnglishTitle] = useState<string>('');
  const [japaneseTitle, setJapaneseTitle] = useState<string>('');

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

  // Edit Submit
  const onEditSubmit = async () => {
    try {
      const problemImageNames = service.extractImageNames(problemImageURLs);
      const solutionImageNames = service.extractImageNames(solutionImageURLs);

      const editQuestion: entity.EditQuestion = {
        id: id,
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

      await service.editQuestion(editQuestion);
      alert('更新成功！');
      router.push('/question');
    } catch (error) {
      alert(`エラーが発生しました:\n${error}`);
    }
  };

  // Delete Submit
  const onDeleteSubmit = async () => {
    try {
      await service.deleteQuestion(id);
      alert('削除成功！');
      router.push('/question');
    } catch (error) {
      alert(`エラーが発生しました:\n${error}`);
    }
  };

  // Fetch Question
  useEffect(() => {
    if (!id) return;
    const loadQuestion = async () => {
      try {
        const question: entity.Question = await service.fetchQuestion(id);
        setOrder(question.order);
        setEnglishTitle(question.englishTitle ?? DEFAULT_QUESTION_ENGLISH_TITLE);
        setJapaneseTitle(question.japaneseTitle ?? DEFAULT_QUESTION_JAPANESE_TITLE);
        setCategory(question.category ?? '');
        setNumber(question.number ?? 0);
        setDifficulty(question.difficulty ?? 1);
        setProblemImageURLs(question.problemImageUrls);
        setSolutionImageURLs(question.solutionImageUrls);
        setReferences(question.references);
      } catch (error) {
        alert(`エラーが発生しました:\n${error}`);
      }
    };
    loadQuestion();
  }, [id]);

  return (
    <main className="wrapper">
      <h1>学習問題編集</h1>

      <form>
        {/* ID */}
        <div className="reaction-edit-content">
          <label htmlFor="id">ID</label>
          <input
            type="text"
            name="id"
            value={id ?? ''}
            readOnly
          />
          <hr />
        </div>

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

        {/* Edit Submit */}
        <button
          type="button"
          className="reaction-edit-add-reaction-button"
          onClick={() => onEditSubmit()}
        >
          <div style={{
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            backgroundColor: '#DF5C44',
            color: 'white',
            padding: '15px 60px',
            borderRadius: '5px',
            fontSize: '16px',
            fontWeight: 'bold',
          }}>
            更新
          </div>
        </button>

        {/* Delete Submit */}
        <button
          type="button"
          className="reaction-edit-add-reaction-button"
          onClick={() => onDeleteSubmit()}
        >
          <div style={{
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            backgroundColor: '#443322',
            color: 'white',
            padding: '15px 60px',
            borderRadius: '5px',
            fontSize: '16px',
            fontWeight: 'bold',
          }}>
            削除
          </div>
        </button>
      </form>
    </main>
  );
}
