package output

type Reaction struct {
	ID                      string
	EnglishName             string
	JapaneseName            string
	ThumbnailImageURL       string
	GeneralFormulaImageURLs []string
	MechanismsImageURLs     []string
	ExampleImageURLs        []string
	SupplementsImageURLs    []string
	Suggestions             []string
	Reactants               []string
	Products                []string
	YoutubeUrls             []string
}
