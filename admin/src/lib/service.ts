import * as entity from '@/lib/entity';
import * as repository from '@/lib/repository';


//////////////////////////////////////////////////////////////
// Handle Images Change
//////////////////////////////////////////////////////////////
export const handleImagesChange = (
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
      try {
        const imageURL = await repository.uploadImage(base64String);
        setImageUrls([...imageUrls, imageURL]);          
      } catch (error) {
        alert(`画像のアップロードに失敗しました:\n${error}`);
      }
    };
    reader.readAsDataURL(file);
  }

  if (inputRef.current) {
    inputRef.current.value = '';
  }
};


//////////////////////////////////////////////////////////////
// Handle Images Delete
//////////////////////////////////////////////////////////////
export const handleImagesDelete = (
  index: number,
  setImageURLs: React.Dispatch<React.SetStateAction<string[]>>
) => {
  setImageURLs((prev) => prev.filter((_, idx) => idx !== index));
};


//////////////////////////////////////////////////////////////
// Handle Image Change
//////////////////////////////////////////////////////////////
export const handleImageChange = (
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
      const img = new Image();
      img.onload = async () => {
        if (img.width === 1772 || img.width === 3898) {} else {
          alert("画像の横幅は1772 or 3898にする必要があります。");
          return;
        }

        try {
          const imageURL = await repository.uploadImage(base64String);
          setImageUrl(imageURL);
        } catch (error) {
          alert(`画像のアップロードに失敗しました:\n${error}`);
        }
      };
      img.onerror = () => {
        alert("画像の読み込みに失敗しました。");
      };
      img.src = base64String;
    };
    reader.readAsDataURL(file);
  }

  if (inputRef.current) {
    inputRef.current.value = '';
  }
};


//////////////////////////////////////////////////////////////
// Handle Image Delete
//////////////////////////////////////////////////////////////
export const handleImageDelete = (
  setImageURL: React.Dispatch<React.SetStateAction<string>>
) => {
  setImageURL('');
};


//////////////////////////////////////////////////////////////
// Handle Texts Change
//////////////////////////////////////////////////////////////
export const handleTextsChange = (
  e: React.ChangeEvent<HTMLInputElement>,
  index: number,
  setTexts: React.Dispatch<React.SetStateAction<string[]>>,
  texts: string[]
) => {
    const newTexts = [...texts];
    newTexts[index] = e.target.value;
    setTexts(newTexts);
};


//////////////////////////////////////////////////////////////
// Handle Texts Delete
//////////////////////////////////////////////////////////////
export const handleTextDelete = (
  index: number,
  setTexts: React.Dispatch<React.SetStateAction<string[]>>,
) => {
    setTexts((prev) => prev.filter((_, idx) => idx !== index));
};


//////////////////////////////////////////////////////////////
// Handle Texts Add
//////////////////////////////////////////////////////////////
export const handleTextsAdd = (
  setTexts: React.Dispatch<React.SetStateAction<string[]>>,
  texts: string[],
) => {
    setTexts([...texts, '']);
};


//////////////////////////////////////////////////////////////
// Extract Image
//////////////////////////////////////////////////////////////
export function extractImageName(url: string): string {
  const parsedUrl = new URL(url);
  const pathname = parsedUrl.pathname;
  const fileName = pathname.substring(pathname.lastIndexOf('/') + 1);
  return fileName.split('?')[0].split('#')[0];
}


//////////////////////////////////////////////////////////////
// Extract Images
//////////////////////////////////////////////////////////////
export function extractImageNames(urls: string[]): string[] {
  return urls.map((url) => extractImageName(url));
}


//////////////////////////////////////////////////////////////
// Fetch Reactions
//////////////////////////////////////////////////////////////
export async function fetchReactions(): Promise<entity.Reaction[]> {
    return await repository.fetchReactions();
}


//////////////////////////////////////////////////////////////
// Fetch Reaction
//////////////////////////////////////////////////////////////
export async function fetchReaction(id: string): Promise<entity.Reaction> {
    return await repository.fetchReaction(id);
}


//////////////////////////////////////////////////////////////
// Add Reaction
//////////////////////////////////////////////////////////////
export async function addReaction(addReaction: entity.AddReaction) {
    // validate
    if (!addReaction.englishName) {
      throw new Error('英語名が入力されていません');
    }

    if (!addReaction.japaneseName) {
      throw new Error('日本語名が入力されていません');
    }

    await repository.addReaction(addReaction);
}


//////////////////////////////////////////////////////////////
// Edit Reaction
//////////////////////////////////////////////////////////////
export async function editReaction(editReaction: entity.EditReaction) {
    await repository.editReaction(editReaction);
}


//////////////////////////////////////////////////////////////
// Delete Reaction
//////////////////////////////////////////////////////////////
export async function deleteReaction(id: string) {
    await repository.deleteReaction(id);
}


//////////////////////////////////////////////////////////////
// Generate Reactions
//////////////////////////////////////////////////////////////
export async function generateReactions() {
    await repository.generateReactions();
}




//////////////////////////////////////////////////////////////
// Handle Selection Change
//////////////////////////////////////////////////////////////
export const handleSelectionChange = (
  selectedValues: string[],
  setSelectedValues: React.Dispatch<React.SetStateAction<string[]>>
) => {
  setSelectedValues(selectedValues);
};


//////////////////////////////////////////////////////////////
// Handle Selection Delete
//////////////////////////////////////////////////////////////
export const handleSelectionDelete = (
  index: number,
  setSelectedValues: React.Dispatch<React.SetStateAction<string[]>>,
) => {
  setSelectedValues((prev) => prev.filter((_, idx) => idx !== index));
};


//////////////////////////////////////////////////////////////
// Handle Selection Add
//////////////////////////////////////////////////////////////
export const handleSelectionAdd = (
  setSelectedValues: React.Dispatch<React.SetStateAction<string[]>>,
  selectedValues: string[],
) => {
  setSelectedValues([...selectedValues, '']);
};


//////////////////////////////////////////////////////////////
// Validator
//////////////////////////////////////////////////////////////
// function isValidUUID(value: string | null | undefined): boolean {
//   if (!value || value.trim().length === 0) {
//     return false; // 空、null、undefined は無効
//   }

//   const uuidRegex = /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;

//   return uuidRegex.test(value); // 正しいUUIDなら true
// }
