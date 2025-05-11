type UploadUrlResponse = {
    uploadUrl: string;
  };
  


// Reaction 型を定義
export type Reaction = {
    id: string;
    englishName: string;
    japaneseName: string;
    thumbnailImageUrl: string;
    generalFormulaImageNames: string[];
    mechanismsImageUrls: string[];
    exampleImageUrls: string[];
    supplementsImageUrls: string[];
    suggestions: string[];
    reactants: string[];
    products: string[];
    youtubeUrls: string[];
  };

type ReactionList = {
    reactions: Reaction[]
}


export type AddReaction = {
    englishName: string;
    japaneseName: string;
    thumbnailImageName: string;
    generalFormulaImageNames: string[];
    mechanismsImageNames: string[];
    exampleImageNames: string[];
    supplementsImageNames: string[];
    suggestions: string[];
    reactants: string[];
    products: string[];
    youtubeUrls: string[];
}


export type EditReaction = {
    id: string,
    englishName: string;
    japaneseName: string;
    thumbnailImageName: string;
    generalFormulaImageNames: string[];
    mechanismsImageNames: string[];
    exampleImageNames: string[];
    supplementsImageNames: string[];
    suggestions: string[];
    reactants: string[];
    products: string[];
    youtubeUrls: string[];
}

  export async function fetchReaction(): Promise<Reaction[]> {
    const response = await fetch("https://admin.reaction-development.swiswiswift.com/api/reaction/list") 
    const reactionList: ReactionList = await response.json();
    const reactions = reactionList.reactions
    return reactions;
}

export async function fetchReaction2(id: string): Promise<Reaction> {
    const response = await fetch(`https://admin.reaction-development.swiswiswift.com/api/reaction/detail/${id}`) 
    const reaction: Reaction = await response.json();
    return reaction;
}

export async function fetchImage(url: string): Promise<string>  {
  const response = await fetch(url);
  if (!response.ok) {
    throw new Error(`画像の取得に失敗しました（ステータス: ${response.status}）`);
  }

  const blob = await response.blob();
  return await new Promise((resolve, reject) => {
    const reader = new FileReader();
    reader.onloadend = () => {
      if (reader.result && typeof reader.result === 'string') {
        resolve(reader.result);
      } else {
        reject(new Error('画像のbase64変換に失敗しました'));
      }
    };
    reader.onerror = () => {
      reject(new Error('FileReaderでの読み込みに失敗しました'));
    };
    reader.readAsDataURL(blob);
  });
}

export async function addReaction(addReaction: AddReaction) {
    const response = await fetch("https://admin.reaction-development.swiswiswift.com/api/reaction/add", {
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



export async function editReaction(editReaction: EditReaction) {
    const response = await fetch("https://admin.reaction-development.swiswiswift.com/api/reaction/edit", {
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


export async function deleteReaction(id: string) {
    const response = await fetch("https://admin.reaction-development.swiswiswift.com/api/reaction/delete", {
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



export async function uploadImage(imageName: string, image: string) {
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
}



export async function generateUploadUrl(imageName: string) {
    const response = await fetch("https://admin.reaction-development.swiswiswift.com/api/generate-upload-url", {
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

  const uploadUrlResponseJson: UploadUrlResponse = await response.json();
  return uploadUrlResponseJson.uploadUrl
}
