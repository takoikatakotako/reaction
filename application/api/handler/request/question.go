package request

type AddQuestion struct {
	Order              int      `json:"order"`
	EnglishTitle       string   `json:"englishTitle"`
	JapaneseTitle      string   `json:"japaneseTitle"`
	Category           string   `json:"category"`
	Number             int      `json:"number"`
	Difficulty         int      `json:"difficulty"`
	ProblemImageNames  []string `json:"problemImageNames"`
	SolutionImageNames []string `json:"solutionImageNames"`
	References         []string `json:"references"`
}

type EditQuestion struct {
	ID                 string   `json:"id"`
	Order              int      `json:"order"`
	EnglishTitle       string   `json:"englishTitle"`
	JapaneseTitle      string   `json:"japaneseTitle"`
	Category           string   `json:"category"`
	Number             int      `json:"number"`
	Difficulty         int      `json:"difficulty"`
	ProblemImageNames  []string `json:"problemImageNames"`
	SolutionImageNames []string `json:"solutionImageNames"`
	References         []string `json:"references"`
}

type DeleteQuestion struct {
	ID string `json:"id"`
}
