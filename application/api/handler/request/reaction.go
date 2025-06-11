package request

type AddReaction struct {
	EnglishName              string   `json:"englishName"`
	JapaneseName             string   `json:"japaneseName"`
	ThumbnailImageName       string   `json:"thumbnailImageName"`
	GeneralFormulaImageNames []string `json:"generalFormulaImageNames"`
	MechanismsImageNames     []string `json:"mechanismsImageNames"`
	ExampleImageNames        []string `json:"exampleImageNames"`
	SupplementsImageNames    []string `json:"supplementsImageNames"`
	Suggestions              []string `json:"suggestions"`
	Reactants                []string `json:"reactants"`
	Products                 []string `json:"products"`
	YoutubeUrls              []string `json:"youtubeUrls"`
}

type EditReaction struct {
	ID                       string   `json:"id"`
	EnglishName              string   `json:"englishName"`
	JapaneseName             string   `json:"japaneseName"`
	ThumbnailImageName       string   `json:"thumbnailImageName"`
	GeneralFormulaImageNames []string `json:"generalFormulaImageNames"`
	MechanismsImageNames     []string `json:"mechanismsImageNames"`
	ExampleImageNames        []string `json:"exampleImageNames"`
	SupplementsImageNames    []string `json:"supplementsImageNames"`
	Suggestions              []string `json:"suggestions"`
	Reactants                []string `json:"reactants"`
	Products                 []string `json:"products"`
	YoutubeUrls              []string `json:"youtubeUrls"`
}

type DeleteReaction struct {
	ID string `file:"id"`
}
