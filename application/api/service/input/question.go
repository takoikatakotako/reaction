package input

type GetQuestion struct {
	ID string
}

type AddQuestion struct {
	Order              int
	EnglishTitle       string
	JapaneseTitle      string
	Category           string
	Number             int
	Difficulty         int
	ProblemImageNames  []string
	SolutionImageNames []string
	References         []string
}

type EditQuestion struct {
	ID                 string
	Order              int
	EnglishTitle       string
	JapaneseTitle      string
	Category           string
	Number             int
	Difficulty         int
	ProblemImageNames  []string
	SolutionImageNames []string
	References         []string
}

type DeleteQuestion struct {
	ID string
}
