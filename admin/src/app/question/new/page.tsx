'use client';

import React, { useState, useRef } from 'react';
import { useRouter } from 'next/navigation';
import ImagesInputField from '../../reaction/common/ImagesInputField';
import TextsInputField from '../../reaction/common/TextsInputField';
import * as service from '@/lib/service';
import * as entity from '@/lib/entity';

export default function NewQuestionPage() {
  const router = useRouter();

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
