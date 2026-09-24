package input

type GetNotice struct {
	ID string
}

type AddNotice struct {
	EnglishTitle  string
	JapaneseTitle string
	EnglishBody   string
	JapaneseBody  string
	PublishedAt   string
}

type EditNotice struct {
	ID            string
	EnglishTitle  string
	JapaneseTitle string
	EnglishBody   string
	JapaneseBody  string
	PublishedAt   string
}

type DeleteNotice struct {
	ID string
}
