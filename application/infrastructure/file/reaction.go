package file

type Reaction struct {
	ID                      string   `file:"id"`
	EnglishName             string   `file:"englishName"`
	JapaneseName            string   `file:"japaneseName"`
	ThumbnailImageURL       string   `file:"thumbnailImageUrl"`
	GeneralFormulaImageURLs []string `file:"generalFormulaImageUrls"`
	MechanismsImageURLs     []string `file:"mechanismsImageUrls"`
	ExampleImageURLs        []string `file:"exampleImageUrls"`
	SupplementsImageURLs    []string `file:"supplementsImageUrls"`
	Suggestions             []string `file:"suggestions"`
	Reactants               []string `file:"reactants"`
	Products                []string `file:"products"`
	YoutubeUrls             []string `file:"youtubeUrls"`
}

//type GetReactions struct {
//	Reactions []Reaction `file:"reactions"`
//}
