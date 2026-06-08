package output

type Question struct {
	ID                string
	Order             int
	EnglishTitle      string
	JapaneseTitle     string
	Category          string
	Number            int
	Difficulty        int
	ProblemImageURLs  []string
	SolutionImageURLs []string
	References        []string
}
