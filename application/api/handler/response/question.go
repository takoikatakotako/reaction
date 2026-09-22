package response

type Question struct {
	ID                string   `json:"id"`
	Order             int      `json:"order"`
	EnglishTitle      string   `json:"englishTitle"`
	JapaneseTitle     string   `json:"japaneseTitle"`
	Category          string   `json:"category"`
	Number            int      `json:"number"`
	Difficulty        int      `json:"difficulty"`
	ProblemImageURLs  []string `json:"problemImageUrls"`
	SolutionImageURLs []string `json:"solutionImageUrls"`
	References        []string `json:"references"`
}

type GetQuestions struct {
	Questions []Question `json:"questions"`
}
