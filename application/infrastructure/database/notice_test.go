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
