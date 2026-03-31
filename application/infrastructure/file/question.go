package file

type Question struct {
	ID                 string   `json:"id"`
	ProblemImageURLs   []string `json:"problemImageUrls"`
	SolutionImageURLs  []string `json:"solutionImageUrls"`
	References         []string `json:"references"`
}

type Questions struct {
	Questions []Question `json:"questions"`
}
