package database

import (
	"github.com/stretchr/testify/assert"
	"testing"
	"time"
)

func validNotice() Notice {
	now := time.Now()
	notice := Notice{
		ID:            "20f0c1cd-9c2a-411a-878c-9bd0bb15dc35",
		EnglishTitle:  "Maintenance",
		JapaneseTitle: "メンテナンスのお知らせ",
		EnglishBody:   "We will perform maintenance.",
		JapaneseBody:  "メンテナンスを行います。",
		Platforms:     []string{NoticePlatformIOS, NoticePlatformAndroid},
		Languages:     []string{NoticeLanguageJapanese, NoticeLanguageEnglish},
		PublishedAt:   now.UTC().Format(time.RFC3339),
	}
	notice.SetCreatedAt(now)
	notice.SetUpdatedAt(now)
	return notice
}

func TestNoticeValidate(t *testing.T) {
	notice := validNotice()
	assert.NoError(t, notice.Validate())
}

func TestNoticeValidateInvalidID(t *testing.T) {
	notice := validNotice()
	notice.ID = "not-a-uuid"
	assert.Error(t, notice.Validate())
}

func TestNoticeValidateInvalidPublishedAt(t *testing.T) {
	notice := validNotice()
	notice.PublishedAt = "2026/09/24"
	assert.Error(t, notice.Validate())
}

func TestNoticeValidateEmptyPublishedAt(t *testing.T) {
	notice := validNotice()
	notice.PublishedAt = ""
	assert.Error(t, notice.Validate())
}

func TestNoticeValidateInvalidTimestamps(t *testing.T) {
	notice := validNotice()
	notice.CreatedAt = "yesterday"
	assert.Error(t, notice.Validate())

	notice = validNotice()
	notice.UpdatedAt = "tomorrow"
	assert.Error(t, notice.Validate())
}

func TestNoticeSetTimestampsAreRFC3339UTC(t *testing.T) {
	notice := Notice{}
	at := time.Date(2026, 9, 24, 12, 34, 56, 0, time.FixedZone("JST", 9*60*60))
	notice.SetCreatedAt(at)
	notice.SetUpdatedAt(at)

	assert.Equal(t, "2026-09-24T03:34:56Z", notice.CreatedAt)
	assert.Equal(t, "2026-09-24T03:34:56Z", notice.UpdatedAt)
}

func TestNoticeValidateTargets(t *testing.T) {
	cases := []struct {
		name      string
		platforms []string
		languages []string
		valid     bool
	}{
		{"iOS のみ", []string{"ios"}, []string{"ja", "en"}, true},
		{"Android のみ", []string{"android"}, []string{"ja", "en"}, true},
		{"日本語のみ", []string{"ios"}, []string{"ja"}, true},
		{"OS が空", []string{}, []string{"ja"}, false},
		{"OS が nil", nil, []string{"ja"}, false},
		{"言語が空", []string{"ios"}, []string{}, false},
		{"未知の OS", []string{"windows"}, []string{"ja"}, false},
		{"未知の言語", []string{"ios"}, []string{"fr"}, false},
		{"OS の重複", []string{"ios", "ios"}, []string{"ja"}, false},
		{"言語の重複", []string{"ios"}, []string{"en", "en"}, false},
	}
	for _, c := range cases {
		t.Run(c.name, func(t *testing.T) {
			notice := validNotice()
			notice.Platforms = c.platforms
			notice.Languages = c.languages
			if c.valid {
				assert.NoError(t, notice.Validate())
			} else {
				assert.Error(t, notice.Validate())
			}
		})
	}
}

func TestNoticeValidateTitleRequiredOnlyForTargetLanguages(t *testing.T) {
	notice := validNotice()
	notice.Languages = []string{NoticeLanguageJapanese}
	notice.EnglishTitle = ""
	assert.NoError(t, notice.Validate())

	notice.JapaneseTitle = ""
	assert.Error(t, notice.Validate())

	notice = validNotice()
	notice.Languages = []string{NoticeLanguageEnglish}
	notice.JapaneseTitle = ""
	assert.NoError(t, notice.Validate())

	notice.EnglishTitle = ""
	assert.Error(t, notice.Validate())
}

func TestNoticeTargetsDefaultToAllForLegacyData(t *testing.T) {
	// 項目追加前のデータは platforms / languages を持たない
	notice := Notice{}
	assert.Equal(t, []string{"ios", "android"}, notice.TargetPlatforms())
	assert.Equal(t, []string{"ja", "en"}, notice.TargetLanguages())
	assert.True(t, notice.IsTargetPlatform(NoticePlatformAndroid))
	assert.True(t, notice.IsTargetLanguage(NoticeLanguageEnglish))
}

func TestNoticeTargetsReturnStoredValues(t *testing.T) {
	notice := Notice{Platforms: []string{"android"}, Languages: []string{"ja"}}
	assert.Equal(t, []string{"android"}, notice.TargetPlatforms())
	assert.False(t, notice.IsTargetPlatform(NoticePlatformIOS))
	assert.False(t, notice.IsTargetLanguage(NoticeLanguageEnglish))
}
