'use client';

import React, { useState, useRef, ChangeEvent, useEffect } from 'react';
import { useSearchParams, useRouter } from 'next/navigation';
import Image from 'next/image';
import TextInputField from '../common/TextInputField';
import TextsInputField from '../common/TextsInputField';
import ImageInputField from '../common/ImageInputField';
import ImagesInputField from '../common/ImagesInputField';
import * as service from '@/lib/service';
import * as entity from '@/lib/entity';

export default function EditUser() {
  // ID
  const searchParams = useSearchParams();
  const id: string = searchParams.get('id') ?? '';

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
      router.push('/');
    } catch (error) {
      alert(`エラーが発生しました:\n${error}`);
    }
  };

  // Delete Submit
  const onDeleteSubmit = async () => {
    try {
      await service.deleteReaction(id);
      alert('削除成功！');
      router.push('/');
    } catch (error) {
      alert(`エラーが発生しました:\n${error}`);
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
      } catch (error) {
        alert(`エラーが発生しました:\n${error}`);
      }
    };
    loadReaction();
  }, [id]);

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
        <TextsInputField
          label="reactants"
          name="Reactants"
          texts={reactants}
          onTextsChange={onReactansChange}
          onTextsDelete={onReactionsDelete}
          onTextsAdd={onReactionsAdd}
        />

        {/* Products */}
        <TextsInputField
          label="products"
          name="Products"
          texts={products}
          onTextsChange={onProductsChange}
          onTextsDelete={onProductsDelete}
          onTextsAdd={onProductsAdd}
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

        {/* Edit Submit */}
        <button
          type="button"
          className="reaction-edit-add-reaction-button"
          onClick={() => onEditSubmit()}
        >
          <Image src="/edit-reaction.svg" alt="" width={200} height={60} />
        </button>

        {/* Delete Submit */}
        <button
          type="button"
          className="reaction-edit-add-reaction-button"
          onClick={() => onDeleteSubmit()}
        >
          <Image src="/delete-reaction.svg" alt="" width={200} height={60} />
        </button>
      </form>
    </main>
  );
}
