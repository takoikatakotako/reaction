package output

type Reaction struct {
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
