package input

type GetQuestion struct {
	ID string
}

type AddQuestion struct {
	ProblemImageNames  []string
	SolutionImageNames []string
	References         []string
}

type EditQuestion struct {
	ID                 string
	ProblemImageNames  []string
	SolutionImageNames []string
	References         []string
}

type DeleteQuestion struct {
	ID string
}
