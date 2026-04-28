package response

type Question struct {
	ID                string   `json:"id"`
	Order             int      `json:"order"`
	ProblemImageURLs  []string `json:"problemImageUrls"`
	SolutionImageURLs []string `json:"solutionImageUrls"`
	References        []string `json:"references"`
}

type GetQuestions struct {
	Questions []Question `json:"questions"`
}
