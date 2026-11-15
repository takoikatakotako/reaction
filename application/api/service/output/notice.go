package output

type Notice struct {
	ID            string
	EnglishTitle  string
	JapaneseTitle string
	EnglishBody   string
	JapaneseBody  string
	Platforms     []string
	Languages     []string
	PublishedAt   string
}
