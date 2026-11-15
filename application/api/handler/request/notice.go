package request

type AddNotice struct {
	EnglishTitle  string   `json:"englishTitle"`
	JapaneseTitle string   `json:"japaneseTitle"`
	EnglishBody   string   `json:"englishBody"`
	JapaneseBody  string   `json:"japaneseBody"`
	Platforms     []string `json:"platforms"`
	Languages     []string `json:"languages"`
	PublishedAt   string   `json:"publishedAt"`
}

type EditNotice struct {
	ID            string   `json:"id"`
	EnglishTitle  string   `json:"englishTitle"`
	JapaneseTitle string   `json:"japaneseTitle"`
	EnglishBody   string   `json:"englishBody"`
	JapaneseBody  string   `json:"japaneseBody"`
	Platforms     []string `json:"platforms"`
	Languages     []string `json:"languages"`
	PublishedAt   string   `json:"publishedAt"`
}

type DeleteNotice struct {
	ID string `json:"id"`
}
