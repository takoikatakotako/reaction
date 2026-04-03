'use client';

import React, { useState, useRef, useEffect } from 'react';
import { useSearchParams, useRouter } from 'next/navigation';
import ImagesInputField from '../../reaction/common/ImagesInputField';
import TextsInputField from '../../reaction/common/TextsInputField';
import * as service from '@/lib/service';
import * as entity from '@/lib/entity';

export default function EditQuestion() {
  const searchParams = useSearchParams();
  const id: string = searchParams.get('id') ?? '';
  const router = useRouter();

  // Order
  const [order, setOrder] = useState<number>(0);

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
    const loadQuestion = async () => {
      try {
        const question: entity.Question = await service.fetchQuestion(id);
        setOrder(question.order);
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
            backgroundColor: '#007bff',
            color: 'white',
            padding: '15px 30px',
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
            backgroundColor: '#dc3545',
            color: 'white',
            padding: '15px 30px',
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
