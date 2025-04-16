'use client';

import React, { useState, useRef, ChangeEvent, FormEvent } from 'react';

interface MyFormData {
  englishName: string;
  japaneseName: string;
  youtubeUrls: string[];
}

export default function AboutPage() {
  const [formData, setFormData] = useState<MyFormData>({
    englishName: '',
    japaneseName: '',
    youtubeUrls: [''],
  });

  const [englishName, setEnglishName] = useState<string>('');
  const [japaneseName, setJapaneseName] = useState<string>('');
  const [thumbnailImage, setThumbnailImage] = useState<string>('');

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

        <div className="reaction-edit-content">
          <label htmlFor="thumbnail">Thumbnail</label>
          <input
            type="file"
            multiple // 画像を複数選択できるようにする
            accept="image/jpeg, image/png"
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
              <button className="reaction-edit-image-delete-button">
                <img src="/image-delete.svg" />
              </button>
            </div>
          )}

          <hr />
        </div>

        <div className="reaction-edit-content">
          <label htmlFor="thumbnail">General Formulas</label>

          <div className="reaction-edit-image-container">
            <img className="reaction-edit-image" src="/image-placeholder.png" />
            {/*  <button class="reaction-edit-image-delete-button"><img src="/image-delete.svg"/></button> */}
          </div>
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
