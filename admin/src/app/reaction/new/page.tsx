'use client';

import React, { useState, useRef, ChangeEvent, FormEvent } from 'react';
import { v4 as uuidv4 } from 'uuid';
import { uploadImage, AddReaction, addReaction, deleteReaction } from '@/lib/api';

export default function AboutPage() {

// ----- common ----
const handleImageURLChange = (
  e: React.ChangeEvent<HTMLInputElement>,
  setImageUrl: React.Dispatch<React.SetStateAction<string>>,
  inputRef: React.RefObject<HTMLInputElement | null>
) => {
  const files = e.target.files;

  if (files && files.length > 0) {
    const file = files[0];
    const reader = new FileReader();

    reader.onloadend = async () => {
      const base64String = reader.result as string;
      const imageName = `${uuidv4()}.png`;
      try {
        await uploadImage(imageName, base64String);
        setImageUrl(imageName)  
      } catch (err) {
        alert("アップロードに失敗しました");
      }
    };
    reader.readAsDataURL(file);
  }

  if (inputRef.current) {
    inputRef.current.value = '';
  }
};

const handleImageURLsChange = (
  e: React.ChangeEvent<HTMLInputElement>,
  setImageUrls: React.Dispatch<React.SetStateAction<string[]>>,
  imageUrls: string[],
  inputRef: React.RefObject<HTMLInputElement | null>
) => {
  const files = e.target.files;

  if (files && files.length > 0) {
    const file = files[0];
    const reader = new FileReader();

    reader.onloadend = async () => {
      const base64String = reader.result as string;
      const imageName = `${uuidv4()}.png`;
      try {
        await uploadImage(imageName, base64String);
        setImageUrls([...imageUrls, base64String]);          
      } catch (err) {
        alert("アップロードに失敗しました");
      }
    };
    reader.readAsDataURL(file);
  }

  if (inputRef.current) {
    inputRef.current.value = '';
  }
};

// 共通の削除ハンドラ
const handleImageURLsDelete = (
  index: number,
  setImageURLs: React.Dispatch<React.SetStateAction<string[]>>
) => {
  setImageURLs((prev) => prev.filter((_, idx) => idx !== index));
};

const handleImageURLDelete = (
  setImageURL: React.Dispatch<React.SetStateAction<string>>
) => {
  setImageURL('');
};


// Text 
const handleTextsChange = (
  e: React.ChangeEvent<HTMLInputElement>,
  index: number,
  setTexts: React.Dispatch<React.SetStateAction<string[]>>,
  texts: string[]
) => {
    const newTexts = [...texts];
    newTexts[index] = e.target.value;
    setTexts(newTexts);
};

const handleTextDelete = (
  index: number,
  setTexts: React.Dispatch<React.SetStateAction<string[]>>,
  texts: string[],
) => {
    setTexts((texts) => texts.filter((_, idx) => idx !== index));
};

const handleTextAdd = (
  setTexts: React.Dispatch<React.SetStateAction<string[]>>,
  texts: string[],
) => {
    setTexts([...texts, '']);
};

function extractImageName(url: string): string {
  const parsedUrl = new URL(url);
  const pathname = parsedUrl.pathname;
  const fileName = pathname.substring(pathname.lastIndexOf('/') + 1);
  return fileName.split('?')[0].split('#')[0];
}

function extractImageNames(urls: string[]): string[] {
  return urls.map((url) => extractImageName(url));
}
// ----- common ----



  // English Name
  const [englishName, setEnglishName] = useState<string>('');
  const onEnglishNameChange = (e: ChangeEvent<HTMLInputElement>) => {
    setEnglishName(e.target.value);
  };

  // Japanese Name
  const [japaneseName, setJapaneseName] = useState<string>('');
  const onJapaneseNameChange = (e: ChangeEvent<HTMLInputElement>) => {
    setJapaneseName(e.target.value);
  };

  // Thumbnail
  const [thumbnailImageURL, setThumbnailImageURL] = useState<string>('');
  const thumbnailInputRef = useRef<HTMLInputElement>(null);
  const onThumbnailChange = (e: React.ChangeEvent<HTMLInputElement>) =>
    handleImageURLChange(e, setThumbnailImageURL, thumbnailInputRef);
  const onThumbnailDelete = () =>
    handleImageURLDelete(setThumbnailImageURL);

  // Mechanisms
  const [mechanismaImageURLs, setMechanismasImageURLs] = useState<string[]>([]);
  const mechanismsInputRef = useRef<HTMLInputElement>(null);
  const onMechanismsChange = (e: React.ChangeEvent<HTMLInputElement>) =>
    handleImageURLsChange(e, setMechanismasImageURLs, mechanismaImageURLs, mechanismsInputRef);
  const onMechanismsDelete = (index: number) =>
    handleImageURLsDelete(index, setMechanismasImageURLs);

  // General Formulas
  const [generalFormulaImageURLs, setGeneralFormulaImageURLs] = useState<string[]>(
    []
  );
  const generalFormulasInputRef = useRef<HTMLInputElement>(null);
  const onGeneralFormulasChange = (e: React.ChangeEvent<HTMLInputElement>) =>
    handleImageURLsChange(e, setGeneralFormulaImageURLs, generalFormulaImageURLs, generalFormulasInputRef);
  const onGeneralFormulasDelete = (index: number) =>
    handleImageURLsDelete(index, setGeneralFormulaImageURLs);

  // Examples
    const [exampleImageURLs, setExampleImageUrls] = useState<string[]>(
    []
  );
  const examplesInputRef = useRef<HTMLInputElement>(null);
  const onExamplesChange = (e: React.ChangeEvent<HTMLInputElement>) =>
    handleImageURLsChange(e, setExampleImageUrls, exampleImageURLs, examplesInputRef);
  const onExamplesDelete = (index: number) =>
    handleImageURLsDelete(index, setExampleImageUrls);

  // Supplements
  const [supplementsImageURLs, setSupplementsImageURLs] = useState<string[]>([]);
  const supplementsInputRef = useRef<HTMLInputElement>(null);
  const onSupplementsChange = (e: React.ChangeEvent<HTMLInputElement>) =>
    handleImageURLsChange(e, setSupplementsImageURLs, supplementsImageURLs, supplementsInputRef);
  const onSupplementsDelete = (index: number) =>
    handleImageURLsDelete(index, setSupplementsImageURLs);

  // Suggestions
  const [suggestions, setSuggestions] = useState<string[]>([]);
  const onSuggestionsChange = (e: React.ChangeEvent<HTMLInputElement>, index: number) =>
    handleTextsChange(e, index, setSuggestions, suggestions);
  const onSuggestionsDelete = (index: number) => {
    handleTextDelete(index, setSuggestions, suggestions)
  };
  const onSuggestionsAdd = () => {
    handleTextAdd(setSuggestions, suggestions)
  };

  // Reactants
  const [reactants, setReactants] = useState<string[]>([]);
  const onReactansChange = (e: React.ChangeEvent<HTMLInputElement>, index: number) =>
    handleTextsChange(e, index, setReactants, reactants);
  const onReactionsDelete = (index: number) => {
    handleTextDelete(index, setReactants, reactants)
  };
  const onReactionsAdd = () => {
    handleTextAdd(setReactants, reactants)
  };

  // Products
  const [products, setProducts] = useState<string[]>([]);
  const onProductsChange = (e: React.ChangeEvent<HTMLInputElement>, index: number) =>
    handleTextsChange(e, index, setProducts, products);
  const onProductsDelete = (index: number) => {
    handleTextDelete(index, setProducts, products)
  };
  const onProductsAdd = () => {
    handleTextAdd(setProducts, products)
  };

  // YoutubeURLs
  const [youtubeURLs, setYoutubeURLs] = useState<string[]>([]);
  const onYoutubeURLsChange = (e: React.ChangeEvent<HTMLInputElement>, index: number) =>
    handleTextsChange(e, index, setYoutubeURLs, youtubeURLs);
  const onYoutubeURLsDelete = (index: number) => {
    handleTextDelete(index, setYoutubeURLs, youtubeURLs)
  };
  const onYoutubeURLsAdd = () => {
    handleTextAdd(setYoutubeURLs, youtubeURLs)
  };




  // Submit
  const submitHandleChange = async () => {
    try {
      const thumbnailImageName = extractImageName(thumbnailImageURL);
      const generalFormulaImageNames = extractImageNames(generalFormulaImageURLs);
      const mechanismImageNames = extractImageNames(mechanismaImageURLs);
      const exampleImageNames = extractImageNames(exampleImageURLs);
      const supplementsImageNames = extractImageNames(supplementsImageURLs);

      // Add Reaction
      const newReaction: AddReaction = {
        englishName: englishName,
        japaneseName: japaneseName,
        thumbnailImageName: thumbnailImageName,
        generalFormulaImageNames: generalFormulaImageNames,
        mechanismsImageNames: mechanismImageNames,
        exampleImageNames: exampleImageNames,
        supplementsImageNames: supplementsImageNames,
        suggestions: suggestions,
        reactants: reactants,
        products: products,
        youtubeUrls: youtubeURLs,
      };

      await addReaction(newReaction);
      alert('送信成功！');
    } catch (error) {
      alert('エラーが発生しました');
    }
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
            onChange={onEnglishNameChange}
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
            onChange={onJapaneseNameChange}
          />
          <hr />
        </div>

        {/* Thumbnail */}
        <div className="reaction-edit-content">
          <label htmlFor="thumbnail">Thumbnail</label>
          <input
            type="file"
            accept="image/png"
            onChange={onThumbnailChange}
            ref={thumbnailInputRef}
          />

          {thumbnailImageURL === '' ? (
            <div className="reaction-edit-image-container">
              <img
                className="reaction-edit-image"
                src="/image-placeholder.png"
              />
            </div>
          ) : (
            <div className="reaction-edit-image-container">
              <img className="reaction-edit-image" src={thumbnailImageURL} />
              <button
                type="button"
                className="reaction-edit-image-delete-button"
                onClick={onThumbnailDelete}
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
            onChange={onGeneralFormulasChange}
            ref={generalFormulasInputRef}
          />

          {generalFormulaImageURLs.length === 0 && (
            <div className="reaction-edit-image-container">
              <img
                className="reaction-edit-image"
                src="/image-placeholder.png"
              />
            </div>
          )}

          {generalFormulaImageURLs.length !== 0 &&
            generalFormulaImageURLs.map((url, index) => (
              <div className="reaction-edit-image-container">
                <img className="reaction-edit-image" src={url} />
                <button
                  type="button"
                  className="reaction-edit-image-delete-button"
                  onClick={() => onGeneralFormulasDelete(index)}
                >
                  <img src="/image-delete.svg" />
                </button>
              </div>
            ))}

          <hr />
        </div>

        {/* Mechanisms */}
        <div className="reaction-edit-content">
          <label htmlFor="thumbnail">Mechanisms</label>
          <input
            type="file"
            accept="image/png"
            onChange={onMechanismsChange}
            ref={mechanismsInputRef}
          />

          {mechanismaImageURLs.length === 0 && (
            <div className="reaction-edit-image-container">
              <img
                className="reaction-edit-image"
                src="/image-placeholder.png"
              />
            </div>
          )}

          {mechanismaImageURLs.length !== 0 &&
            mechanismaImageURLs.map((url, index) => (
              <div className="reaction-edit-image-container">
                <img className="reaction-edit-image" src={url} />
                <button
                  type="button"
                  className="reaction-edit-image-delete-button"
                  onClick={() => onMechanismsDelete}
                >
                  <img src="/image-delete.svg" />
                </button>
              </div>
            ))}
          <hr />
        </div>

        {/* Examples */}
        <div className="reaction-edit-content">
          <label htmlFor="thumbnail">Examples</label>
          <input
            type="file"
            accept="image/png"
            onChange={onExamplesChange}
            ref={examplesInputRef}
          />

          {exampleImageURLs.length === 0 && (
            <div className="reaction-edit-image-container">
              <img
                className="reaction-edit-image"
                src="/image-placeholder.png"
              />
            </div>
          )}

          {exampleImageURLs.length !== 0 &&
            exampleImageURLs.map((image, index) => (
              <div className="reaction-edit-image-container">
                <img className="reaction-edit-image" src={image} />
                <button
                  type="button"
                  className="reaction-edit-image-delete-button"
                  onClick={() => onExamplesDelete(index)}
                >
                  <img src="/image-delete.svg" />
                </button>
              </div>
            ))}

          <hr />
        </div>

        {/* Supplements */}
        <div className="reaction-edit-content">
          <label htmlFor="thumbnail">Supplements</label>
          <input
            type="file"
            accept="image/png"
            onChange={onSupplementsChange}
            ref={supplementsInputRef}
          />

          {supplementsImageURLs.length === 0 && (
            <div className="reaction-edit-image-container">
              <img
                className="reaction-edit-image"
                src="/image-placeholder.png"
              />
            </div>
          )}

          {supplementsImageURLs.length !== 0 &&
            supplementsImageURLs.map((url, index) => (
              <div className="reaction-edit-image-container">
                <img className="reaction-edit-image" src={url} />
                <button
                  type="button"
                  className="reaction-edit-image-delete-button"
                  onClick={() => onSupplementsDelete(index)}
                >
                  <img src="/image-delete.svg" />
                </button>
              </div>
            ))}
          <hr />
        </div>

        {/* Suggestions */}
        <div className="reaction-edit-content">
          <label htmlFor="englishName">Suggestions</label>

          {suggestions.length !== 0 &&
            suggestions.map((suggestion, index) => (
              <div key={index}>
                <div className="reaction-edit-multi-input-container">
                  <input
                    type="text"
                    name="englishName"
                    value={suggestion}
                    placeholder="サジェスチョンの単語を入力"
                    onChange={(e) => onSuggestionsChange(e, index)}
                  />
                  <button
                    type="button"
                    className="reaction-edit-image-delete-button"
                    onClick={() => onSuggestionsDelete(index)}
                  >
                    <img src="/image-delete.svg" />
                  </button>
                </div>
                <hr />
              </div>
            ))}

          <button
            type="button"
            className="reaction-edit-multi-input-plus-button"
            onClick={() => onSuggestionsAdd()}
          >
            <img src="/plus.svg" />
          </button>
        </div>

        {/* Reactants */}
        <div className="reaction-edit-content">
          <label htmlFor="englishName">Reactants</label>

          {reactants.length !== 0 &&
            reactants.map((reactant, index) => (
              <div key={index}>
                <div className="reaction-edit-multi-input-container">
                  <input
                    type="text"
                    name="englishName"
                    value={reactant}
                    placeholder="反応物の単語を入力"
                    onChange={(e) => onReactansChange(e, index)}
                  />
                  <button
                    type="button"
                    className="reaction-edit-image-delete-button"
                    onClick={() => onReactionsDelete(index)}
                  >
                    <img src="/image-delete.svg" />
                  </button>
                </div>
                <hr />
              </div>
            ))}

          <button
            type="button"
            className="reaction-edit-multi-input-plus-button"
            onClick={() => onReactionsAdd()}
          >
            <img src="/plus.svg" />
          </button>
        </div>

        {/* Products */}
        <div className="reaction-edit-content">
          <label htmlFor="englishName">Products</label>

          {products.length !== 0 &&
            products.map((product, index) => (
              <div key={index}>
                <div className="reaction-edit-multi-input-container">
                  <input
                    type="text"
                    name="englishName"
                    value={product}
                    placeholder="精製物の単語を入力"
                    onChange={(e) => onProductsChange(e, index)}
                  />
                  <button
                    type="button"
                    className="reaction-edit-image-delete-button"
                    onClick={() => onProductsDelete(index)}
                  >
                    <img src="/image-delete.svg" />
                  </button>
                </div>
                <hr />
              </div>
            ))}

          <button
            type="button"
            className="reaction-edit-multi-input-plus-button"
            onClick={() => onProductsAdd()}
          >
            <img src="/plus.svg" />
          </button>
        </div>

        {/* Youtube */}
        <div className="reaction-edit-content">
          <label htmlFor="englishName">Youtube</label>

          {youtubeURLs.length !== 0 &&
            youtubeURLs.map((url, index) => (
              <div key={index}>
                <div className="reaction-edit-multi-input-container">
                  <input
                    type="text"
                    name="englishName"
                    value={url}
                    placeholder="Youtubeのリンクを入力"
                    onChange={(e) => onYoutubeURLsChange(e, index)}
                  />
                  <button
                    type="button"
                    className="reaction-edit-image-delete-button"
                    onClick={() => onYoutubeURLsDelete(index)}
                  >
                    <img src="/image-delete.svg" />
                  </button>
                </div>
                <hr />
              </div>
            ))}

          <button
            type="button"
            className="reaction-edit-multi-input-plus-button"
            onClick={() => onYoutubeURLsAdd()}
          >
            <img src="/plus.svg" />
          </button>

          {/* Submit */}
          <button
            type="button"
            className="reaction-edit-add-reaction-button"
            onClick={() => submitHandleChange()}
          >
            <img src="/add-reaction.svg" />
          </button>
        </div>
      </form>
    </main>
  );
}
