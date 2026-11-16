package database

import (
	"errors"
	"github.com/takoikatakotako/reaction/common"
	"slices"
	"time"
)

const (
	NoticeTableName = "notices"
	NoticeTableID   = "id"
)

// お知らせの対象プラットフォーム
const (
	NoticePlatformIOS     = "ios"
	NoticePlatformAndroid = "android"
)

// お知らせの対象言語
const (
	NoticeLanguageJapanese = "ja"
	NoticeLanguageEnglish  = "en"
)

var (
	AllNoticePlatforms = []string{NoticePlatformIOS, NoticePlatformAndroid}
	AllNoticeLanguages = []string{NoticeLanguageJapanese, NoticeLanguageEnglish}
)

type Notice struct {
	ID            string `dynamodbav:"id"`
	EnglishTitle  string `dynamodbav:"englishTitle"`
	JapaneseTitle string `dynamodbav:"japaneseTitle"`
	EnglishBody   string `dynamodbav:"englishBody"`
	JapaneseBody  string `dynamodbav:"japaneseBody"`
	// 対象の OS と言語。項目追加前のデータには無いので、空なら「すべて」として扱う
	// （TargetPlatforms / TargetLanguages を通して読むこと）
	Platforms []string `dynamodbav:"platforms"`
	Languages []string `dynamodbav:"languages"`
	// 一覧の並び順と表示日に使う
	PublishedAt string `dynamodbav:"publishedAt"`
	CreatedAt   string `dynamodbav:"createdAt"`
	UpdatedAt   string `dynamodbav:"updatedAt"`
}

func (n *Notice) SetCreatedAt(createdAt time.Time) {
	n.CreatedAt = createdAt.UTC().Format(time.RFC3339)
}

func (n *Notice) SetUpdatedAt(updatedAt time.Time) {
	n.UpdatedAt = updatedAt.UTC().Format(time.RFC3339)
}

// TargetPlatforms は対象 OS を返す。未設定（項目追加前のデータ）ならすべての OS。
func (n *Notice) TargetPlatforms() []string {
	if len(n.Platforms) == 0 {
		return append([]string{}, AllNoticePlatforms...)
	}
	return n.Platforms
}

// TargetLanguages は対象言語を返す。未設定（項目追加前のデータ）ならすべての言語。
func (n *Notice) TargetLanguages() []string {
	if len(n.Languages) == 0 {
		return append([]string{}, AllNoticeLanguages...)
	}
	return n.Languages
}

func (n *Notice) IsTargetPlatform(platform string) bool {
	return slices.Contains(n.TargetPlatforms(), platform)
}

func (n *Notice) IsTargetLanguage(language string) bool {
	return slices.Contains(n.TargetLanguages(), language)
}

func (n *Notice) Validate() error {
	if !IsValidUUID(n.ID) {
		return errors.New(common.ErrorInvalidValue + ": ID")
	}

	// 保存するデータは対象を明示させる（空は旧データの読み込み時だけ許容する）
	if !isValidTargets(n.Platforms, AllNoticePlatforms) {
		return errors.New(common.ErrorInvalidValue + ": Platforms")
	}

	if !isValidTargets(n.Languages, AllNoticeLanguages) {
		return errors.New(common.ErrorInvalidValue + ": Languages")
	}

	// 対象言語のタイトルは必須
	if n.IsTargetLanguage(NoticeLanguageJapanese) && n.JapaneseTitle == "" {
		return errors.New(common.ErrorInvalidValue + ": JapaneseTitle")
	}

	if n.IsTargetLanguage(NoticeLanguageEnglish) && n.EnglishTitle == "" {
		return errors.New(common.ErrorInvalidValue + ": EnglishTitle")
	}

	if _, err := time.Parse(time.RFC3339, n.PublishedAt); err != nil {
		return errors.New(common.ErrorInvalidValue + ": PublishedAt")
	}

	if _, err := time.Parse(time.RFC3339, n.CreatedAt); err != nil {
		return errors.New(common.ErrorInvalidValue + ": CreatedAt")
	}

	if _, err := time.Parse(time.RFC3339, n.UpdatedAt); err != nil {
		return errors.New(common.ErrorInvalidValue + ": UpdatedAt")
	}

	return nil
}

// 1つ以上あり、すべて許可された値で、重複が無いこと
func isValidTargets(values []string, allowed []string) bool {
	if len(values) == 0 {
		return false
	}
	seen := map[string]bool{}
	for _, v := range values {
		if !slices.Contains(allowed, v) || seen[v] {
			return false
		}
		seen[v] = true
	}
	return true
}
