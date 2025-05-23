package input

type GetReaction struct {
	ID string
}

type AddReaction struct {
	EnglishName              string
	JapaneseName             string
	ThumbnailImageName       string
	GeneralFormulaImageNames []string
	MechanismsImageNames     []string
	ExampleImageNames        []string
	SupplementsImageNames    []string
	Suggestions              []string
	Reactants                []string
	Products                 []string
	YoutubeUrls              []string
}

type EditReaction struct {
	ID                       string
	EnglishName              string
	JapaneseName             string
	ThumbnailImageName       string
	GeneralFormulaImageNames []string
	MechanismsImageNames     []string
	ExampleImageNames        []string
	SupplementsImageNames    []string
	Suggestions              []string
	Reactants                []string
	Products                 []string
	YoutubeUrls              []string
}

type DeleteReaction struct {
	ID string
}
