'use client';

import React, { useState, useRef, ChangeEvent } from 'react';
import { useRouter } from 'next/navigation';
import Image from 'next/image';
import TextInputField from '../common/TextInputField';
import TextsInputField from '../common/TextsInputField';
import SelectField from '../common/SelectField';
import ImageInputField from '../common/ImageInputField';
import ImagesInputField from '../common/ImagesInputField';
import * as service from '@/lib/service';
import * as entity from '@/lib/entity';
import { REACTANT_OPTIONS, PRODUCT_OPTIONS } from '@/lib/constants';

export default function AboutPage() {
  // Router
  const router = useRouter();

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
  const onReactantsSelectionChange = (selectedValues: string[]) => {
    service.handleSelectionChange(selectedValues, setReactants);
  };
  const onReactantsDelete = (index: number) => {
    service.handleSelectionDelete(index, setReactants);
  };
  const onReactantsAdd = () => {
    service.handleSelectionAdd(setReactants, reactants);
  };

  // Products
  const [products, setProducts] = useState<string[]>([]);
  const onProductsSelectionChange = (selectedValues: string[]) => {
    service.handleSelectionChange(selectedValues, setProducts);
  };
  const onProductsDelete = (index: number) => {
    service.handleSelectionDelete(index, setProducts);
  };
  const onProductsAdd = () => {
    service.handleSelectionAdd(setProducts, products);
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
      if (!thumbnailImageURL) {
        throw new Error('サムネイルが入力されていません');
      }

      // Validate reactants
      const hasEmptyReactant = reactants.some(reactant => !reactant || reactant === '');
      if (hasEmptyReactant) {
        throw new Error('Reactantsで「選択してください」のままの項目があります');
      }
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
      router.push('/');
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
        <ImagesInputField
          label="generalFormulas"
          name="General Formulas"
          imageURLs={generalFormulaImageURLs}
          inputRef={generalFormulasInputRef}
          onImageChange={onGeneralFormulasChange}
          onImageDelete={onGeneralFormulasDelete}
        />

        {/* Mechanisms */}
        <ImagesInputField
          label="mechanisms"
          name="Mechanisms"
          imageURLs={mechanismaImageURLs}
          inputRef={mechanismsInputRef}
          onImageChange={onMechanismsChange}
          onImageDelete={onMechanismsDelete}
        />

        {/* Examples */}
        <ImagesInputField
          label="examples"
          name="Examples"
          imageURLs={exampleImageURLs}
          inputRef={examplesInputRef}
          onImageChange={onExamplesChange}
          onImageDelete={onExamplesDelete}
        />

        {/* Supplements */}
        <ImagesInputField
          label="supplements"
          name="Supplements"
          imageURLs={supplementsImageURLs}
          inputRef={supplementsInputRef}
          onImageChange={onSupplementsChange}
          onImageDelete={onSupplementsDelete}
        />

        {/* Suggestions */}
        <TextsInputField
          label="suggestions"
          name="Suggestions"
          texts={suggestions}
          onTextsChange={onSuggestionsChange}
          onTextsDelete={onSuggestionsDelete}
          onTextsAdd={onSuggestionsAdd}
        />

        {/* Reactants */}
        <SelectField
          label="reactants"
          name="Reactants"
          options={REACTANT_OPTIONS}
          selectedValues={reactants}
          onSelectionChange={onReactantsSelectionChange}
          onSelectionAdd={onReactantsAdd}
          onSelectionDelete={onReactantsDelete}
        />

        {/* Products */}
        <SelectField
          label="products"
          name="Products"
          options={PRODUCT_OPTIONS}
          selectedValues={products}
          onSelectionChange={onProductsSelectionChange}
          onSelectionAdd={onProductsAdd}
          onSelectionDelete={onProductsDelete}
        />

        {/* Youtube */}
        <TextsInputField
          label="youtubes"
          name="Youtube"
          texts={youtubeURLs}
          onTextsChange={onYoutubeURLsChange}
          onTextsDelete={onYoutubeURLsDelete}
          onTextsAdd={onYoutubeURLsAdd}
        />

        {/* Submit */}
        <button
          type="button"
          className="reaction-edit-add-reaction-button"
          onClick={() => submitHandleChange()}
        >
          <Image src="/add-reaction.svg" alt="" width={200} height={60} />
        </button>
      </form>
    </main>
  );
}
