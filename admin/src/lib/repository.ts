import { v4 as uuidv4 } from 'uuid';
import * as entity from '@/lib/entity';

const apiBaseUrl = process.env.NEXT_PUBLIC_API_BASE_URL;
const resourceBaseUrl = process.env.NEXT_PUBLIC_RESOURCE_BASE_URL;


//////////////////////////////////////////////////////////////
// Fetch Reactions
//////////////////////////////////////////////////////////////
export async function fetchReactions(): Promise<entity.Reaction[]> {
    const response = await fetch(apiBaseUrl + "/api/reaction/list") 
    const reactionList: entity.ReactionList = await response.json();
    const reactions = reactionList.reactions
    return reactions;
}


//////////////////////////////////////////////////////////////
// Fetch Reaction
//////////////////////////////////////////////////////////////
export async function fetchReaction(id: string): Promise<entity.Reaction> {
    const response = await fetch(apiBaseUrl + `/api/reaction/detail/${id}`) 
    const reaction: entity.Reaction = await response.json();
    return reaction;
}


//////////////////////////////////////////////////////////////
// Add Reaction
//////////////////////////////////////////////////////////////
export async function addReaction(addReaction: entity.AddReaction) {
    const response = await fetch(apiBaseUrl + "/api/reaction/add", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          englishName: addReaction.englishName,
          japaneseName: addReaction.japaneseName,
          thumbnailImageName: addReaction.thumbnailImageName,
          generalFormulaImageNames: addReaction.generalFormulaImageNames,
          mechanismsImageNames: addReaction.mechanismsImageNames,
          exampleImageNames: addReaction.exampleImageNames,
          supplementsImageNames: addReaction.supplementsImageNames,
          suggestions: addReaction.suggestions,
          reactants: addReaction.reactants,
          products: addReaction.products,
          youtubeUrls: addReaction.youtubeUrls,
        }),
      });

      if (!response.ok) {
        throw new Error('反応機構の追加に失敗しました。');
      }
}


//////////////////////////////////////////////////////////////
// Edit Reaction
//////////////////////////////////////////////////////////////
export async function editReaction(editReaction: entity.EditReaction) {
    const response = await fetch(apiBaseUrl + "/api/reaction/edit", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          id: editReaction.id,
          englishName: editReaction.englishName,
          japaneseName: editReaction.japaneseName,
          thumbnailImageName: editReaction.thumbnailImageName,
          generalFormulaImageNames: editReaction.generalFormulaImageNames,
          mechanismsImageNames: editReaction.mechanismsImageNames,
          exampleImageNames: editReaction.exampleImageNames,
          supplementsImageNames: editReaction.supplementsImageNames,
          suggestions: editReaction.suggestions,
          reactants: editReaction.reactants,
          products: editReaction.products,
          youtubeUrls: editReaction.youtubeUrls,
        }),
      });

      if (!response.ok) {
        throw new Error('反応機構の追加に失敗しました。');
      }
}


//////////////////////////////////////////////////////////////
// Delete Reaction
//////////////////////////////////////////////////////////////
export async function deleteReaction(id: string) {
    const response = await fetch(apiBaseUrl + "/api/reaction/delete", {
        method: "DELETE",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          id: id,
        }),
      });

      if (!response.ok) {
        throw new Error('反応機構の追加に失敗しました。');
      }
}


//////////////////////////////////////////////////////////////
// Generate Upload URL
//////////////////////////////////////////////////////////////
export async function generateUploadUrl(imageName: string) {
    const response = await fetch(apiBaseUrl + "/api/generate-upload-url", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        imageName: imageName,
      }),
    });

    if (!response.ok) {
      throw new Error('アップロード用URLの取得に失敗しました。');
    }

  const uploadUrlResponseJson: entity.UploadUrlResponse = await response.json();
  return uploadUrlResponseJson.uploadUrl
}


//////////////////////////////////////////////////////////////
// Upload Image
//////////////////////////////////////////////////////////////
export async function uploadImage(image: string): Promise<string> {
    const imageName = `${uuidv4()}.png`;
    const uploadUrl = await generateUploadUrl(imageName)
    const matches = image.match(/^data:(.+);base64,(.*)$/);
    if (!matches || matches.length !== 3) {
        throw new Error("サムネイル画像の変換に失敗しました。");
    }

    const contentType = matches[1];
    const imageBase64Data = matches[2];
    const imageBuffer = Buffer.from(imageBase64Data, 'base64')
    const uploadImageResponse = await fetch(uploadUrl, {
      method: 'PUT',
      headers: {
        'Content-Type': contentType,
      },
      body: imageBuffer,
    });

    if (!uploadImageResponse.ok) {
        throw new Error("サムネイルのアップロードに失敗しました。");
    }

    return resourceBaseUrl + "/" + imageName;
}


//////////////////////////////////////////////////////////////
// Generate Reaction
//////////////////////////////////////////////////////////////
export async function generateReactions() {
    const response = await fetch(apiBaseUrl + "/api/reaction/generate", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        }
      });

      console.log(response.body);

      if (!response.ok) {
        throw new Error('反応機構の更新に失敗しました。');
      }
}

