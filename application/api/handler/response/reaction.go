package response

type Reaction struct {
	ID                      string   `json:"id"`
	EnglishName             string   `json:"englishName"`
	JapaneseName            string   `json:"japaneseName"`
	ThumbnailImageURL       string   `json:"thumbnailImageUrl"`
	GeneralFormulaImageURLs []string `json:"generalFormulaImageUrls"`
	MechanismsImageURLs     []string `json:"mechanismsImageUrls"`
	ExampleImageURLs        []string `json:"exampleImageUrls"`
	SupplementsImageURLs    []string `json:"supplementsImageUrls"`
	Suggestions             []string `json:"suggestions"`
	Reactants               []string `json:"reactants"`
	Products                []string `json:"products"`
	YoutubeUrls             []string `json:"youtubeUrls"`
}

type GetReactions struct {
	Reactions []Reaction `json:"reactions"`
}
