package request

type AddQuestion struct {
	ProblemImageNames  []string `json:"problemImageNames"`
	SolutionImageNames []string `json:"solutionImageNames"`
	References         []string `json:"references"`
}

type EditQuestion struct {
	ID                 string   `json:"id"`
	ProblemImageNames  []string `json:"problemImageNames"`
	SolutionImageNames []string `json:"solutionImageNames"`
	References         []string `json:"references"`
}

type DeleteQuestion struct {
	ID string `json:"id"`
}
