'use client';

import React, { useState, useRef, ChangeEvent, useEffect } from 'react';
import { useSearchParams } from 'next/navigation';
import * as service from '@/lib/service';
import * as entity from '@/lib/entity';

export default function EditUser() {
  // ID
  const searchParams = useSearchParams();
  const id: string = searchParams.get('id') ?? '';

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
    service.handleImageChange(e, setThumbnailImageURL, thumbnailInputRef);
  const onThumbnailDelete = () =>
    service.handleImageDelete(setThumbnailImageURL);

  // Mechanisms
  const [mechanismaImageURLs, setMechanismasImageURLs] = useState<string[]>([]);
  const mechanismsInputRef = useRef<HTMLInputElement>(null);
  const onMechanismsChange = (e: React.ChangeEvent<HTMLInputElement>) =>
    service.handleImagesChange(
      e,
      setMechanismasImageURLs,
      mechanismaImageURLs,
      mechanismsInputRef
    );
  const onMechanismsDelete = (index: number) =>
    service.handleImagesDelete(index, setMechanismasImageURLs);

  // General Formulas
  const [generalFormulaImageURLs, setGeneralFormulaImageURLs] = useState<
    string[]
  >([]);
  const generalFormulasInputRef = useRef<HTMLInputElement>(null);
  const onGeneralFormulasChange = (e: React.ChangeEvent<HTMLInputElement>) =>
    service.handleImagesChange(
      e,
      setGeneralFormulaImageURLs,
      generalFormulaImageURLs,
      generalFormulasInputRef
    );
  const onGeneralFormulasDelete = (index: number) =>
    service.handleImagesDelete(index, setGeneralFormulaImageURLs);

  // Examples
  const [exampleImageURLs, setExampleImageUrls] = useState<string[]>([]);
  const examplesInputRef = useRef<HTMLInputElement>(null);
  const onExamplesChange = (e: React.ChangeEvent<HTMLInputElement>) =>
    service.handleImagesChange(
      e,
      setExampleImageUrls,
      exampleImageURLs,
      examplesInputRef
    );
  const onExamplesDelete = (index: number) =>
    service.handleImagesDelete(index, setExampleImageUrls);

  // Supplements
  const [supplementsImageURLs, setSupplementsImageURLs] = useState<string[]>(
    []
  );
  const supplementsInputRef = useRef<HTMLInputElement>(null);
  const onSupplementsChange = (e: React.ChangeEvent<HTMLInputElement>) =>
    service.handleImagesChange(
      e,
      setSupplementsImageURLs,
      supplementsImageURLs,
      supplementsInputRef
    );
  const onSupplementsDelete = (index: number) =>
    service.handleImagesDelete(index, setSupplementsImageURLs);

  // Suggestions
  const [suggestions, setSuggestions] = useState<string[]>([]);
  const onSuggestionsChange = (
    e: React.ChangeEvent<HTMLInputElement>,
    index: number
  ) => service.handleTextsChange(e, index, setSuggestions, suggestions);
  const onSuggestionsDelete = (index: number) => {
    service.handleTextDelete(index, setSuggestions, suggestions);
  };
  const onSuggestionsAdd = () => {
    service.handleTextsAdd(setSuggestions, suggestions);
  };

  // Reactants
  const [reactants, setReactants] = useState<string[]>([]);
  const onReactansChange = (
    e: React.ChangeEvent<HTMLInputElement>,
    index: number
  ) => service.handleTextsChange(e, index, setReactants, reactants);
  const onReactionsDelete = (index: number) => {
    service.handleTextDelete(index, setReactants, reactants);
  };
  const onReactionsAdd = () => {
    service.handleTextsAdd(setReactants, reactants);
  };

  // Products
  const [products, setProducts] = useState<string[]>([]);
  const onProductsChange = (
    e: React.ChangeEvent<HTMLInputElement>,
    index: number
  ) => service.handleTextsChange(e, index, setProducts, products);
  const onProductsDelete = (index: number) => {
    service.handleTextDelete(index, setProducts, products);
  };
  const onProductsAdd = () => {
    service.handleTextsAdd(setProducts, products);
  };

  // YoutubeURLs
  const [youtubeURLs, setYoutubeURLs] = useState<string[]>([]);
  const onYoutubeURLsChange = (
    e: React.ChangeEvent<HTMLInputElement>,
    index: number
  ) => service.handleTextsChange(e, index, setYoutubeURLs, youtubeURLs);
  const onYoutubeURLsDelete = (index: number) => {
    service.handleTextDelete(index, setYoutubeURLs, youtubeURLs);
  };
  const onYoutubeURLsAdd = () => {
    service.handleTextsAdd(setYoutubeURLs, youtubeURLs);
  };

  // Edit Submit
  const onEditSubmit = async () => {
    try {
      const thumbnailImageName = service.extractImageName(thumbnailImageURL);
      const generalFormulaImageNames = service.extractImageNames(
        generalFormulaImageURLs
      );
      const mechanismImageNames =
        service.extractImageNames(mechanismaImageURLs);
      const exampleImageNames = service.extractImageNames(exampleImageURLs);
      const supplementsImageNames =
        service.extractImageNames(supplementsImageURLs);

      // Edit Reaction
      const editReaction: entity.EditReaction = {
        id: id,
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

      await service.editReaction(editReaction);
      alert('編集成功！');
    } catch (error) {
      alert('エラーが発生しました');
    }
  };

  // Delete Submit
  const onDeleteSubmit = async () => {
    try {
      await service.deleteReaction(id);
      alert('送信成功！');
    } catch (error) {
      alert('エラーが発生しました');
    }
  };

  // Fetch Reaction
  useEffect(() => {
    const loadReaction = async () => {
      try {
        const reaction: entity.Reaction = await service.fetchReaction(id);
        setEnglishName(reaction.englishName);
        setJapaneseName(reaction.japaneseName);
        setThumbnailImageURL(reaction.thumbnailImageUrl);
        setGeneralFormulaImageURLs(reaction.generalFormulaImageUrls);
        setMechanismasImageURLs(reaction.mechanismsImageUrls);
        setExampleImageUrls(reaction.exampleImageUrls);
        setSupplementsImageURLs(reaction.exampleImageUrls);
        setSuggestions(reaction.suggestions);
        setReactants(reaction.reactants);
        setProducts(reaction.products);
        setYoutubeURLs(reaction.youtubeUrls);
      } catch (err) {
        alert('エラーが発生しました');
      }
    };
    loadReaction();
  }, []);

  return (
 <main className="wrapper">
      <h1>反応機構編集</h1>

      <form>
        {/* ID */}
        <div className="reaction-edit-content">
          <label htmlFor="id">ID</label>
          <input
            type="text"
            name="id"
            placeholder="反応機構の英語名を入力"
            value={id ?? ''}
            readOnly
          />
          <hr />
        </div>

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
              <div className="reaction-edit-image-container" key={index}>
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
              <div className="reaction-edit-image-container" key={index}>
                <img className="reaction-edit-image" src={url} />
                <button
                  type="button"
                  className="reaction-edit-image-delete-button"
                  onClick={() => onMechanismsDelete(index)}
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
            exampleImageURLs.map((url, index) => (
              <div className="reaction-edit-image-container" key={index}>
                <img className="reaction-edit-image" src={url} />
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
              <div className="reaction-edit-image-container" key={index}>
                <img className="reaction-edit-image" src={url} />
                <button
                  type="button"
                  className="reaction-edit-image-delete-button"
                  onClick={() => onSuggestionsDelete(index)}
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
            onClick={() => onProductsAdd}
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

          {/* Edit Submit */}
          <button
            type="button"
            className="reaction-edit-add-reaction-button"
            onClick={() => onEditSubmit()}
          >
            <img src="/edit-reaction.svg" />
          </button>

          {/* Delete Submit */}
          <button
            type="button"
            className="reaction-edit-add-reaction-button"
            onClick={() => onDeleteSubmit()}
          >
            <img src="/delete-reaction.svg" />
          </button>
        </div>
      </form>
    </main>
  );
}
