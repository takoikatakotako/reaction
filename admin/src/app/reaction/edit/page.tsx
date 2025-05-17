'use client';

import React, {
  useState,
  useRef,
  ChangeEvent,
  FormEvent,
  useEffect,
} from 'react';
import { useSearchParams } from 'next/navigation';
import { v4 as uuidv4 } from 'uuid';
import { uploadImage, AddReaction, addReaction, fetchReaction2, Reaction, fetchImage, deleteReaction, fetchImages } from '@/lib/api';

export default function EditUser() {
  const searchParams = useSearchParams();
  const id : string = searchParams.get('id') ?? "";

  const [englishName, setEnglishName] = useState<string>('');
  const [japaneseName, setJapaneseName] = useState<string>('');
  const [thumbnailImageUrl, setThumbnailImageUrl] = useState<string>('');
  const [generalFormulaImageUrls, setGeneralFormulaImageUrls] = useState<string[]>(
    []
  );
  const [mechanismasImageUrls, setMechanismasImageUrls] = useState<string[]>(
    []
  );
  const [exampleImageUrls, setExampleImageUrls] = useState<string[]>([]);
  const [supplementsImageUrls, setSupplementsImageUrls] = useState<string[]>([]);
  const [suggestions, setSuggestions] = useState<string[]>([]);
  const [reactants, setReactants] = useState<string[]>([]);
  const [products, setProducts] = useState<string[]>([]);
  const [youtubes, setYoutubes] = useState<string[]>([]);

  const inputRef = useRef<HTMLInputElement>(null);

  useEffect(() => {
    const loadReaction = async () => {
      try {
        const reaction: Reaction = await fetchReaction2(id);
        setEnglishName(reaction.englishName);
        setJapaneseName(reaction.japaneseName);
        setThumbnailImageUrl(reaction.thumbnailImageUrl);
        setGeneralFormulaImageUrls(reaction.generalFormulaImageUrls);
        setMechanismasImageUrls(reaction.mechanismsImageUrls);
        setExampleImageUrls(reaction.exampleImageUrls);
        setSupplementsImageUrls(reaction.exampleImageUrls);
        setSuggestions(reaction.suggestions);
        setReactants(reaction.reactants);
        setProducts(reaction.products);
        setYoutubes(reaction.youtubeUrls);
      } catch (err) {
        alert('エラーが発生しました');
      }
    };
    loadReaction();
  }, []);

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

      reader.onloadend = async () => {
        const base64String = reader.result as string;
        try {
          const imageName = `${uuidv4()}.png`;
          await uploadImage(imageName, base64String);          
          setThumbnailImageUrl('http://admin-storage.reaction-development.swiswiswift.com.s3-website-ap-northeast-1.amazonaws.com/' + imageName)
        } catch (err) {
          alert("アップロードに失敗しました");
        }
      };
      reader.readAsDataURL(file); // Base64に変換開始
    }

    if (inputRef.current) {
      inputRef.current.value = '';
    }
  };

  const thumbnailDeleteHandleChange = () => {
    setThumbnailImageUrl('');
  };

  // General Formulas
  const generalFormulasHandleChange = (
    e: React.ChangeEvent<HTMLInputElement>
  ) => {
    const files = e.target.files;

    if (files && files.length > 0) {
      const file = files[0];
      const reader = new FileReader();

      reader.onloadend = async () => {
        const base64String = reader.result as string;
        try {
          const imageName = `${uuidv4()}.png`;
          await uploadImage(imageName, base64String);          
          setGeneralFormulaImageUrls([...generalFormulaImageUrls, 'http://admin-storage.reaction-development.swiswiswift.com.s3-website-ap-northeast-1.amazonaws.com/' + imageName]);
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

  const generalFormulasDeleteHandleChange = (index: number) => {
    setGeneralFormulaImageUrls((prev) => prev.filter((_, idx) => idx !== index));
  };

  // Mechanisms
  const mechanismsHandleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const files = e.target.files;

    if (files && files.length > 0) {
      const file = files[0];
      const reader = new FileReader();

      reader.onloadend = async () => {
        const base64String = reader.result as string;
        try {
          const imageName = `${uuidv4()}.png`;
          await uploadImage(imageName, base64String);          
          setMechanismasImageUrls([...mechanismasImageUrls, 'http://admin-storage.reaction-development.swiswiswift.com.s3-website-ap-northeast-1.amazonaws.com/' + imageName]);
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

  const mechanismsDeleteHandleChange = (index: number) => {
    setMechanismasImageUrls((prev) => prev.filter((_, idx) => idx !== index));
  };

  // Examples
  const examplesHandleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const files = e.target.files;

    if (files && files.length > 0) {
      const file = files[0];
      const reader = new FileReader();

      reader.onloadend = () => {
        const base64String = reader.result as string;
        setExampleImages([...generalFormulaImages, base64String]);
      };
      reader.readAsDataURL(file);
    }

    if (inputRef.current) {
      inputRef.current.value = '';
    }
  };

  const examplessDeleteHandleChange = (index: number) => {
    setExampleImages((prev) => prev.filter((_, idx) => idx !== index));
  };

  // Supplements
  const supplementsHandleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const files = e.target.files;

    if (files && files.length > 0) {
      const file = files[0];
      const reader = new FileReader();

      reader.onloadend = () => {
        const base64String = reader.result as string;
        setSupplementsImages([...generalFormulaImages, base64String]);
      };
      reader.readAsDataURL(file);
    }

    if (inputRef.current) {
      inputRef.current.value = '';
    }
  };

  const supplementsDeleteHandleChange = (index: number) => {
    setSupplementsImages((prev) => prev.filter((_, idx) => idx !== index));
  };

  // Suggestions
  const suggestionsUpdateHandleChange = (
    e: React.ChangeEvent<HTMLInputElement>,
    index: number
  ) => {
    const newSuggestions = [...suggestions];
    newSuggestions[index] = e.target.value;
    setSuggestions(newSuggestions);
  };

  const suggestionsDeleteHandleChange = (index: number) => {
    setSuggestions((prev) => prev.filter((_, idx) => idx !== index));
  };

  const suggestionsAddHandleChange = () => {
    setSuggestions([...suggestions, '']);
  };

  // Reactants
  const reactantsUpdateHandleChange = (
    e: React.ChangeEvent<HTMLInputElement>,
    index: number
  ) => {
    const newReactants = [...reactants];
    newReactants[index] = e.target.value;
    setReactants(newReactants);
  };

  const reactantsDeleteHandleChange = (index: number) => {
    setReactants((prev) => prev.filter((_, idx) => idx !== index));
  };

  const reactantsAddHandleChange = () => {
    setReactants([...reactants, '']);
  };

  // Products
  const productsUpdateHandleChange = (
    e: React.ChangeEvent<HTMLInputElement>,
    index: number
  ) => {
    const newProducts = [...products];
    newProducts[index] = e.target.value;
    setProducts(newProducts);
  };

  const productsDeleteHandleChange = (index: number) => {
    setProducts((prev) => prev.filter((_, idx) => idx !== index));
  };

  const productsAddHandleChange = () => {
    setProducts([...products, '']);
  };

  // Youtube
  const youtubesUpdateHandleChange = (
    e: React.ChangeEvent<HTMLInputElement>,
    index: number
  ) => {
    const newYoutubes = [...youtubes];
    newYoutubes[index] = e.target.value;
    setYoutubes(newYoutubes);
  };

  const youtubesDeleteHandleChange = (index: number) => {
    setYoutubes((prev) => prev.filter((_, idx) => idx !== index));
  };

  const youtubesAddHandleChange = () => {
    setYoutubes([...youtubes, '']);
  };

  // Edit Submit
  const editHandleChange = async () => {
    try {
      // Upload Thumbnail
      const thumbnailImageName = `${uuidv4()}.png`;
      await uploadImage(thumbnailImageName, thumbnailImage);

      // Upload General Formulas
      let generalFormulaImageNames: string[] = [];
      for (const generalFormulaImage of generalFormulaImages) {
        const generalFormulaImageName = `${uuidv4()}.png`;
        await uploadImage(generalFormulaImageName, generalFormulaImage);
        generalFormulaImageNames.push(generalFormulaImageName);
      }

      // Upload Mechanisms
      let mechanismImageNames: string[] = [];
      for (const mechanismasImage of mechanismasImages) {
        const mechanismImageName = `${uuidv4()}.png`;
        await uploadImage(mechanismImageName, mechanismasImage);
        mechanismImageNames.push(mechanismImageName);
      }

      // Upload Examples
      let exampleImageNames: string[] = [];
      for (const exampleImage of exampleImages) {
        const exampleImageName = `${uuidv4()}.png`;
        await uploadImage(exampleImageName, exampleImage);
        exampleImageNames.push(exampleImageName);
      }

      // Upload Examples
      let supplementsImageNames: string[] = [];
      for (const supplementsImage of supplementsImages) {
        const supplementsImageName = `${uuidv4()}.png`;
        await uploadImage(supplementsImageName, supplementsImage);
        supplementsImageNames.push(supplementsImageName);
      }

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
        youtubeUrls: youtubes,
      };

      await addReaction(newReaction);

      alert('送信成功！');
    } catch (error) {
      alert('エラーが発生しました');
    }
  };


  // Delete Submit
  const deleteHandleChange = async () => {
    try {
      await deleteReaction(id);

      alert('送信成功！');
    } catch (error) {
      alert('エラーが発生しました');
    }
  }

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

          {thumbnailImageUrl === '' ? (
            <div className="reaction-edit-image-container">
              <img
                className="reaction-edit-image"
                src="/image-placeholder.png"
              />
            </div>
          ) : (
            <div className="reaction-edit-image-container">
              <img className="reaction-edit-image" src={thumbnailImageUrl} />
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

          {generalFormulaImageUrls.length === 0 && (
            <div className="reaction-edit-image-container">
              <img
                className="reaction-edit-image"
                src="/image-placeholder.png"
              />
            </div>
          )}

          {generalFormulaImageUrls.length !== 0 &&
            generalFormulaImageUrls.map((url, idx) => (
              <div className="reaction-edit-image-container" key={idx}>
                <img className="reaction-edit-image" src={url} />
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

        {/* Mechanisms */}
        <div className="reaction-edit-content">
          <label htmlFor="thumbnail">Mechanisms</label>
          <input
            type="file"
            accept="image/png"
            onChange={mechanismsHandleChange}
            ref={inputRef}
          />

          {mechanismasImageUrls.length === 0 && (
            <div className="reaction-edit-image-container">
              <img
                className="reaction-edit-image"
                src="/image-placeholder.png"
              />
            </div>
          )}

          {mechanismasImageUrls.length !== 0 &&
            mechanismasImageUrls.map((url, idx) => (
              <div className="reaction-edit-image-container" key={idx}>
                <img className="reaction-edit-image" src={url} />
                <button
                  type="button"
                  className="reaction-edit-image-delete-button"
                  onClick={() => mechanismsDeleteHandleChange(idx)}
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
            onChange={examplesHandleChange}
            ref={inputRef}
          />

          {exampleImageUrls.length === 0 && (
            <div className="reaction-edit-image-container">
              <img
                className="reaction-edit-image"
                src="/image-placeholder.png"
              />
            </div>
          )}

          {exampleImageUrls.length !== 0 &&
            exampleImageUrls.map((url, idx) => (
              <div className="reaction-edit-image-container" key={idx}>
                <img className="reaction-edit-image" src={url} />
                <button
                  type="button"
                  className="reaction-edit-image-delete-button"
                  onClick={() => examplessDeleteHandleChange(idx)}
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
            onChange={supplementsHandleChange}
            ref={inputRef}
          />

          {supplementsImageUrls.length === 0 && (
            <div className="reaction-edit-image-container">
              <img
                className="reaction-edit-image"
                src="/image-placeholder.png"
              />
            </div>
          )}

          {supplementsImageUrls.length !== 0 &&
            supplementsImageUrls.map((url, idx) => (
              <div className="reaction-edit-image-container" key={idx}>
                <img className="reaction-edit-image" src={url} />
                <button
                  type="button"
                  className="reaction-edit-image-delete-button"
                  onClick={() => supplementsDeleteHandleChange(idx)}
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
            suggestions.map((suggestion, idx) => (
              <div key={idx}>
                <div className="reaction-edit-multi-input-container">
                  <input
                    type="text"
                    name="englishName"
                    value={suggestion}
                    placeholder="サジェスチョンの単語を入力"
                    onChange={(e) => suggestionsUpdateHandleChange(e, idx)}
                  />
                  <button
                    type="button"
                    className="reaction-edit-image-delete-button"
                    onClick={() => suggestionsDeleteHandleChange(idx)}
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
            onClick={() => suggestionsAddHandleChange()}
          >
            <img src="/plus.svg" />
          </button>
        </div>

        {/* Reactants */}
        <div className="reaction-edit-content">
          <label htmlFor="englishName">Reactants</label>

          {reactants.length !== 0 &&
            reactants.map((reactant, idx) => (
              <div key={idx}>
                <div className="reaction-edit-multi-input-container">
                  <input
                    type="text"
                    name="englishName"
                    value={reactant}
                    placeholder="反応物の単語を入力"
                    onChange={(e) => reactantsUpdateHandleChange(e, idx)}
                  />
                  <button
                    type="button"
                    className="reaction-edit-image-delete-button"
                    onClick={() => reactantsDeleteHandleChange(idx)}
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
            onClick={() => reactantsAddHandleChange()}
          >
            <img src="/plus.svg" />
          </button>
        </div>

        {/* Products */}
        <div className="reaction-edit-content">
          <label htmlFor="englishName">Products</label>

          {products.length !== 0 &&
            products.map((product, idx) => (
              <div key={idx}>
                <div className="reaction-edit-multi-input-container">
                  <input
                    type="text"
                    name="englishName"
                    value={product}
                    placeholder="精製物の単語を入力"
                    onChange={(e) => productsUpdateHandleChange(e, idx)}
                  />
                  <button
                    type="button"
                    className="reaction-edit-image-delete-button"
                    onClick={() => productsDeleteHandleChange(idx)}
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
            onClick={() => productsAddHandleChange()}
          >
            <img src="/plus.svg" />
          </button>
        </div>

        {/* Youtube */}
        <div className="reaction-edit-content">
          <label htmlFor="englishName">Youtube</label>

          {youtubes.length !== 0 &&
            youtubes.map((youtube, idx) => (
              <div key={idx}>
                <div className="reaction-edit-multi-input-container">
                  <input
                    type="text"
                    name="englishName"
                    value={youtube}
                    placeholder="Youtubeのリンクを入力"
                    onChange={(e) => youtubesUpdateHandleChange(e, idx)}
                  />
                  <button
                    type="button"
                    className="reaction-edit-image-delete-button"
                    onClick={() => youtubesDeleteHandleChange(idx)}
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
            onClick={() => youtubesAddHandleChange()}
          >
            <img src="/plus.svg" />
          </button>

          {/* Edit Submit */}
          <button
            type="button"
            className="reaction-edit-add-reaction-button"
            onClick={() => editHandleChange()}
          >
            <img src="/edit-reaction.svg" />
          </button>

          {/* Delete Submit */}
          <button
            type="button"
            className="reaction-edit-add-reaction-button"
            onClick={() => deleteHandleChange()}
          >
            <img src="/delete-reaction.svg" />
          </button>
        </div>
      </form>
    </main>
  );
}
