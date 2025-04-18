'use client';

import React, { useState, useRef, ChangeEvent, FormEvent } from 'react';

export default function AboutPage() {
  const [englishName, setEnglishName] = useState<string>('');
  const [japaneseName, setJapaneseName] = useState<string>('');
  const [thumbnailImage, setThumbnailImage] = useState<string>('');
  const [generalFormulaImages, setGeneralFormulaImages] = useState<string[]>(
    []
  );

  const inputRef = useRef<HTMLInputElement>(null);

  // EnglishName
  const englishNameHandleChange = (e: ChangeEvent<HTMLInputElement>) => {
    setEnglishName(e.target.value);
  };

  // JapaneseName
  const japaneseNameHandleChange = (e: ChangeEvent<HTMLInputElement>) => {
    setJapaneseName(e.target.value);
  };

  // Thumbnail
  const thumbnailHandleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const files = e.target.files;

    if (files && files.length > 0) {
      const file = files[0];
      const reader = new FileReader();

      reader.onloadend = () => {
        const base64String = reader.result as string;
        setThumbnailImage(base64String); // Base64をstateにセット
      };
      reader.readAsDataURL(file); // Base64に変換開始
    }

    if (inputRef.current) {
      inputRef.current.value = '';
    }
  };

  // Thumbnail Delete
  const thumbnailDeleteHandleChange = () => {
    setThumbnailImage('');
  };

  // General Formulas
  const generalFormulasHandleChange = (
    e: React.ChangeEvent<HTMLInputElement>
  ) => {
    const files = e.target.files;

    if (files && files.length > 0) {
      const file = files[0];
      const reader = new FileReader();

      reader.onloadend = () => {
        const base64String = reader.result as string;
        setGeneralFormulaImages([...generalFormulaImages, base64String]);
      };
      reader.readAsDataURL(file);
    }

    if (inputRef.current) {
      inputRef.current.value = '';
    }
  };

  // General Formulas Delete
  const generalFormulasDeleteHandleChange =  (index: number) => {
    setGeneralFormulaImages((prev) => prev.filter((_, idx) => idx !== index));
  };


  // フォーム送信時のイベントハンドラ
  const handleSubmit = (e: FormEvent<HTMLFormElement>) => {
    e.preventDefault(); // ページのリロードを防ぐ
    alert(`送信された名前: ${name}`);
    // ここでAPI通信や他の処理ができる
  };

  return (
    <main className="wrapper">
      <h1>反応機構追加</h1>

      <form>
        {/* English Name */}
        <div className="reaction-edit-content">
          <label htmlFor="englishName">EnglishName</label>
          <input
            type="text"
            name="englishName"
            placeholder="反応機構の英語名を入力"
            value={englishName}
            onChange={englishNameHandleChange}
          />
          <hr />
        </div>

        {/* Japanese Name */}
        <div className="reaction-edit-content">
          <label htmlFor="japanseeName">JapaneseName</label>
          <input
            type="text"
            name="japanseeName"
            placeholder="反応機構の日本語名を入力"
            value={japaneseName}
            onChange={japaneseNameHandleChange}
          />
          <hr />
        </div>

        {/* Thumbnail */}
        <div className="reaction-edit-content">
          <label htmlFor="thumbnail">Thumbnail</label>
          <input
            type="file"
            accept="image/png"
            onChange={thumbnailHandleChange}
            ref={inputRef}
          />

          {thumbnailImage === '' ? (
            <div className="reaction-edit-image-container">
              <img
                className="reaction-edit-image"
                src="/image-placeholder.png"
              />
            </div>
          ) : (
            <div className="reaction-edit-image-container">
              <img className="reaction-edit-image" src={thumbnailImage} />
              <button
                type="button"
                className="reaction-edit-image-delete-button"
                onClick={thumbnailDeleteHandleChange}
              >
                <img src="/image-delete.svg" />
              </button>
            </div>
          )}
          <hr />
        </div>

        {/* General Formulas */}
        <div className="reaction-edit-content">
          <label htmlFor="thumbnail">General Formulas</label>
          <input
            type="file"
            accept="image/png"
            onChange={generalFormulasHandleChange}
            ref={inputRef}
          />

          {generalFormulaImages.length === 0 && (
            <div className="reaction-edit-image-container">
              <img
                className="reaction-edit-image"
                src="/image-placeholder.png"
              />
            </div>
          )}

          {generalFormulaImages.length !== 0 &&
            generalFormulaImages.map((image, idx) => (
              <div className="reaction-edit-image-container">
                <img className="reaction-edit-image" src={image} />
                <button
                  type="button"
                  className="reaction-edit-image-delete-button"
                  onClick={() => generalFormulasDeleteHandleChange(idx)}
                >
                  <img src="/image-delete.svg" />
                </button>
              </div>
            ))}

          <hr />
        </div>

        <div className="reaction-edit-content">
          <label htmlFor="thumbnail">Mechanisms</label>

          <div className="reaction-edit-image-container">
            <img className="reaction-edit-image" src="/image-placeholder.png" />
            {/* <button class="reaction-edit-image-delete-button"><img src="/image-delete.svg" /></button> */}
          </div>
          <hr />
        </div>

        <div className="reaction-edit-content">
          <label htmlFor="thumbnail">Examples</label>

          <div className="reaction-edit-image-container">
            <img
              className="reaction-edit-image"
              src="/acetoacetic-ester-synthesis-thumbnail.png"
            />
            <button className="reaction-edit-image-delete-button">
              <img src="/image-delete.svg" />
            </button>
          </div>

          <div className="reaction-edit-image-container">
            <img className="reaction-edit-image" src="/image-placeholder.png" />
            {/* <button class="reaction-edit-image-delete-button"><img src="/image-delete.svg"/></button>*/}
          </div>
          <hr />
        </div>

        <div className="reaction-edit-content">
          <label htmlFor="thumbnail">Supplements</label>

          <div className="reaction-edit-image-container">
            <img
              className="reaction-edit-image"
              src="/acetoacetic-ester-synthesis-thumbnail.png"
            />
            <button className="reaction-edit-image-delete-button">
              <img src="/image-delete.svg" />
            </button>
          </div>

          <div className="reaction-edit-image-container">
            <img className="reaction-edit-image" src="/image-placeholder.png" />
            {/*  <button class="reaction-edit-image-delete-button"><img src="image/image-delete.svg"></button> */}
          </div>
          <hr />
        </div>

        <div className="reaction-edit-content">
          <label htmlFor="englishName">Suggestions</label>
          <div className="reaction-edit-multi-input-container">
            <input
              type="text"
              name="englishName"
              value="Acetoacetic Ester Synthesis"
            />
            <button className="reaction-edit-image-delete-button">
              <img src="/image-delete.svg" />
            </button>
          </div>
          <hr />

          <div className="reaction-edit-multi-input-container">
            <input
              type="text"
              name="englishName"
              value="アセト酢酸エステル合成"
            />
            <button className="reaction-edit-image-delete-button">
              <img src="/image-delete.svg" />
            </button>
          </div>
          <hr />

          <div className="reaction-edit-multi-input-container">
            <input
              type="text"
              name="englishName"
              value=""
              placeholder="サジェスチョンの単語を入力"
            />
            <button className="reaction-edit-image-delete-button">
              <img src="/image-delete.svg" />
            </button>
          </div>
          <hr />

          <button className="reaction-edit-multi-input-plus-button">
            <img src="/plus.svg" />
          </button>
        </div>

        <div className="reaction-edit-content">
          <label htmlFor="englishName">Reactants</label>
          <div className="reaction-edit-multi-input-container">
            <input
              type="text"
              name="englishName"
              value="Acetoacetic Ester Synthesis"
            />
            <button className="reaction-edit-image-delete-button">
              <img src="/image-delete.svg" />
            </button>
          </div>
          <hr />

          <div className="reaction-edit-multi-input-container">
            <input
              type="text"
              name="englishName"
              value="アセト酢酸エステル合成"
            />
            <button className="reaction-edit-image-delete-button">
              <img src="/image-delete.svg" />
            </button>
          </div>
          <hr />

          <div className="reaction-edit-multi-input-container">
            <input
              type="text"
              name="englishName"
              value=""
              placeholder="サジェスチョンの単語を入力"
            />
            <button className="reaction-edit-image-delete-button">
              <img src="/image-delete.svg" />
            </button>
          </div>
          <hr />

          <button className="reaction-edit-multi-input-plus-button">
            <img src="/plus.svg" />
          </button>
        </div>

        <div className="reaction-edit-content">
          <label htmlFor="englishName">Products</label>
          <div className="reaction-edit-multi-input-container">
            <input
              type="text"
              name="englishName"
              value="Acetoacetic Ester Synthesis"
            />
            <button className="reaction-edit-image-delete-button">
              <img src="/image-delete.svg" />
            </button>
          </div>
          <hr />

          <div className="reaction-edit-multi-input-container">
            <input
              type="text"
              name="englishName"
              value="アセト酢酸エステル合成"
            />
            <button className="reaction-edit-image-delete-button">
              <img src="/image-delete.svg" />
            </button>
          </div>
          <hr />

          <div className="reaction-edit-multi-input-container">
            <input
              type="text"
              name="englishName"
              value=""
              placeholder="サジェスチョンの単語を入力"
            />
            <button className="reaction-edit-image-delete-button">
              <img src="/image-delete.svg" />
            </button>
          </div>
          <hr />

          <button className="reaction-edit-multi-input-plus-button">
            <img src="/plus.svg" />
          </button>
        </div>

        <div className="reaction-edit-content">
          <label htmlFor="englishName">Youtube</label>
          <div className="reaction-edit-multi-input-container">
            <input
              type="text"
              name="englishName"
              value="Acetoacetic Ester Synthesis"
            />
            <button className="reaction-edit-image-delete-button">
              <img src="image/image-delete.svg" />
            </button>
          </div>
          <hr />

          <div className="reaction-edit-multi-input-container">
            <input
              type="text"
              name="englishName"
              value="アセト酢酸エステル合成"
            />
            <button className="reaction-edit-image-delete-button">
              <img src="image/image-delete.svg" />
            </button>
          </div>
          <hr />

          <div className="reaction-edit-multi-input-container">
            <input
              type="text"
              name="englishName"
              value=""
              placeholder="サジェスチョンの単語を入力"
            />
            <button className="reaction-edit-image-delete-button">
              <img src="image/image-delete.svg" />
            </button>
          </div>
          <hr />

          <button className="reaction-edit-multi-input-plus-button">
            <img src="/plus.svg" />
          </button>

          <button className="reaction-edit-add-reaction-button">
            <img src="/add-reaction.svg" />
          </button>
        </div>
      </form>
    </main>
  );
}
