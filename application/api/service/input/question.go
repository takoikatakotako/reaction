package input

type GetQuestion struct {
	ID string
}

type AddQuestion struct {
	Order              int
	ProblemImageNames  []string
	SolutionImageNames []string
	References         []string
}

type EditQuestion struct {
	ID                 string
	Order              int
	ProblemImageNames  []string
	SolutionImageNames []string
	References         []string
}

type DeleteQuestion struct {
	ID string
}
