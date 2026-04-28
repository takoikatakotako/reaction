//////////////////////////////////////////////////////////////
// Reaction
//////////////////////////////////////////////////////////////
export type Reaction = {
    id: string;
    englishName: string;
    japaneseName: string;
    thumbnailImageUrl: string;
    generalFormulaImageUrls: string[];
    mechanismsImageUrls: string[];
    exampleImageUrls: string[];
    supplementsImageUrls: string[];
    suggestions: string[];
    reactants: string[];
    products: string[];
    youtubeUrls: string[];
};


//////////////////////////////////////////////////////////////
// Reaction List
//////////////////////////////////////////////////////////////
export type ReactionList = {
    reactions: Reaction[]
}


//////////////////////////////////////////////////////////////
// Add Reaction
//////////////////////////////////////////////////////////////
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


//////////////////////////////////////////////////////////////
// Edit Reaction
//////////////////////////////////////////////////////////////
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


//////////////////////////////////////////////////////////////
// Question
//////////////////////////////////////////////////////////////
export type Question = {
    id: string;
    order: number;
    problemImageUrls: string[];
    solutionImageUrls: string[];
    references: string[];
};


//////////////////////////////////////////////////////////////
// Question List
//////////////////////////////////////////////////////////////
export type QuestionList = {
    questions: Question[]
}


//////////////////////////////////////////////////////////////
// Add Question
//////////////////////////////////////////////////////////////
export type AddQuestion = {
    order: number;
    problemImageNames: string[];
    solutionImageNames: string[];
    references: string[];
}


//////////////////////////////////////////////////////////////
// Edit Question
//////////////////////////////////////////////////////////////
export type EditQuestion = {
    id: string;
    order: number;
    problemImageNames: string[];
    solutionImageNames: string[];
    references: string[];
}


//////////////////////////////////////////////////////////////
// UploadUrlResponse
//////////////////////////////////////////////////////////////
export type UploadUrlResponse = {
    uploadUrl: string;
};
  
