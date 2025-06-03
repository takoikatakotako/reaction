package request

type AddReaction struct {
	EnglishName              string   `file:"englishName"`
	JapaneseName             string   `file:"japaneseName"`
	ThumbnailImageName       string   `file:"thumbnailImageName"`
	GeneralFormulaImageNames []string `file:"generalFormulaImageNames"`
	MechanismsImageNames     []string `file:"mechanismsImageNames"`
	ExampleImageNames        []string `file:"exampleImageNames"`
	SupplementsImageNames    []string `file:"supplementsImageNames"`
	Suggestions              []string `file:"suggestions"`
	Reactants                []string `file:"reactants"`
	Products                 []string `file:"products"`
	YoutubeUrls              []string `file:"youtubeUrls"`
}

type EditReaction struct {
	ID                       string   `file:"id"`
	EnglishName              string   `file:"englishName"`
	JapaneseName             string   `file:"japaneseName"`
	ThumbnailImageName       string   `file:"thumbnailImageName"`
	GeneralFormulaImageNames []string `file:"generalFormulaImageNames"`
	MechanismsImageNames     []string `file:"mechanismsImageNames"`
	ExampleImageNames        []string `file:"exampleImageNames"`
	SupplementsImageNames    []string `file:"supplementsImageNames"`
	Suggestions              []string `file:"suggestions"`
	Reactants                []string `file:"reactants"`
	Products                 []string `file:"products"`
	YoutubeUrls              []string `file:"youtubeUrls"`
}

type DeleteReaction struct {
	ID string `file:"id"`
}
