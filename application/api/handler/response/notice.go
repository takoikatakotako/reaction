package response

type Notice struct {
	ID            string `json:"id"`
	EnglishTitle  string `json:"englishTitle"`
	JapaneseTitle string `json:"japaneseTitle"`
	EnglishBody   string `json:"englishBody"`
	JapaneseBody  string `json:"japaneseBody"`
	PublishedAt   string `json:"publishedAt"`
}

type GetNotices struct {
	Notices []Notice `json:"notices"`
}
