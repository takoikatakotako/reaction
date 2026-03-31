package response

type Question struct {
	ID                string   `json:"id"`
	ProblemImageURLs  []string `json:"problemImageUrls"`
	SolutionImageURLs []string `json:"solutionImageUrls"`
	References        []string `json:"references"`
}

type GetQuestions struct {
	Questions []Question `json:"questions"`
}
