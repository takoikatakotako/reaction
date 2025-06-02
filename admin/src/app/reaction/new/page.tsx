'use client';

import React, { useState, useRef, ChangeEvent } from 'react';
import Image from 'next/image';
import TextInputField from '../common/TextInputField';
import ImageInputField from '../common/ImageInputField';
import * as service from '@/lib/service';
import * as entity from '@/lib/entity';

export default function AboutPage() {
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
    service.handleTextDelete(index, setSuggestions);
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
    service.handleTextDelete(index, setReactants);
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
    service.handleTextDelete(index, setProducts);
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
    service.handleTextDelete(index, setYoutubeURLs);
  };
  const onYoutubeURLsAdd = () => {
    service.handleTextsAdd(setYoutubeURLs, youtubeURLs);
  };

  // Submit
  const submitHandleChange = async () => {
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

      // Add Reaction
      const addReaction: entity.AddReaction = {
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

      await service.addReaction(addReaction);
      alert('送信成功！');
    } catch (error) {
      alert(`エラーが発生しました:\n${error}`);
    }
  };

  return (
    <main className="wrapper">
      <h1>反応機構追加</h1>

      <form>
        {/* English Name */}
        <TextInputField
          label="EnglishName"
          name="englishName"
          placeholder="反応機構の英語名を入力"
          value={englishName}
          onChange={onEnglishNameChange}
        />

        {/* Japanese Name */}
        <TextInputField
          label="JapaneseName"
          name="japaneseName"
          placeholder="反応機構の日本語名を入力"
          value={japaneseName}
          onChange={onJapaneseNameChange}
        />

        {/* Thumbnail */}
        <ImageInputField
          imageURL={thumbnailImageURL}
          inputRef={thumbnailInputRef}
          onImageChange={onThumbnailChange}
          onImageDelete={onThumbnailDelete}
        />

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
              <Image
                className="reaction-edit-image"
                src="/image-placeholder.png"
                alt=""
                width={0}
                height={0}
              />
            </div>
          )}

          {generalFormulaImageURLs.length !== 0 &&
            generalFormulaImageURLs.map((url, index) => (
              <div key={index} className="reaction-edit-image-container">
                <Image
                  className="reaction-edit-image"
                  src={url}
                  alt=""
                  width={0}
                  height={0}
                />
                <button
                  type="button"
                  className="reaction-edit-image-delete-button"
                  onClick={() => onGeneralFormulasDelete(index)}
                >
                  <Image src="/image-delete.svg" alt="" width={0} height={0} />
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
              <Image
                className="reaction-edit-image"
                src="/image-placeholder.png"
                alt=""
                width={0}
                height={0}
              />
            </div>
          )}

          {mechanismaImageURLs.length !== 0 &&
            mechanismaImageURLs.map((url, index) => (
              <div key={index} className="reaction-edit-image-container">
                <Image
                  className="reaction-edit-image"
                  src={url}
                  alt=""
                  width={0}
                  height={0}
                />
                <button
                  type="button"
                  className="reaction-edit-image-delete-button"
                  onClick={() => onMechanismsDelete(index)}
                >
                  <Image src="/image-delete.svg" alt="" width={0} height={0} />
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
              <Image
                className="reaction-edit-image"
                src="/image-placeholder.png"
                width={0}
                height={0}
                alt=""
              />
            </div>
          )}

          {exampleImageURLs.length !== 0 &&
            exampleImageURLs.map((image, index) => (
              <div key={index} className="reaction-edit-image-container">
                <Image
                  className="reaction-edit-image"
                  src={image}
                  alt=""
                  width={0}
                  height={0}
                />
                <button
                  type="button"
                  className="reaction-edit-image-delete-button"
                  onClick={() => onExamplesDelete(index)}
                >
                  <Image src="/image-delete.svg" alt="" width={0} height={0} />
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
              <Image
                className="reaction-edit-image"
                src="/image-placeholder.png"
                alt=""
                width={0}
                height={0}
              />
            </div>
          )}

          {supplementsImageURLs.length !== 0 &&
            supplementsImageURLs.map((url, index) => (
              <div key={index} className="reaction-edit-image-container">
                <Image className="reaction-edit-image" src={url} alt="" />
                <button
                  type="button"
                  className="reaction-edit-image-delete-button"
                  onClick={() => onSupplementsDelete(index)}
                >
                  <Image src="/image-delete.svg" alt="" width={0} height={0} />
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
                    <Image
                      src="/image-delete.svg"
                      alt=""
                      width={0}
                      height={0}
                    />
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
            <Image src="/plus.svg" alt="" width={0} height={0} />
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
                    <Image
                      src="/image-delete.svg"
                      alt=""
                      width={0}
                      height={0}
                    />
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
            <Image src="/plus.svg" alt="" width={0} height={0} />
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
                    <Image
                      src="/image-delete.svg"
                      alt=""
                      width={0}
                      height={0}
                    />
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
            <Image src="/plus.svg" alt="" width={0} height={0} />
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
                    <Image
                      src="/image-delete.svg"
                      alt=""
                      width={0}
                      height={0}
                    />
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
            <Image src="/plus.svg" alt="" width={0} height={0} />
          </button>

          {/* Submit */}
          <button
            type="button"
            className="reaction-edit-add-reaction-button"
            onClick={() => submitHandleChange()}
          >
            <Image src="/add-reaction.svg" alt="" width={200} height={60} />
          </button>
        </div>
      </form>
    </main>
  );
}
