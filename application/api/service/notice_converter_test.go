package service

import (
	"github.com/stretchr/testify/assert"
	"github.com/takoikatakotako/reaction/infrastructure/database"
	"testing"
)

func TestConvertToOutputNotice(t *testing.T) {
	notice := database.Notice{
		ID:            "id-1",
		EnglishTitle:  "Title",
		JapaneseTitle: "タイトル",
		EnglishBody:   "Body",
		JapaneseBody:  "本文",
		PublishedAt:   "2026-09-24T00:00:00Z",
		CreatedAt:     "2026-09-01T00:00:00Z",
		UpdatedAt:     "2026-09-02T00:00:00Z",
	}

	out := convertToOutputNotice(notice)

	assert.Equal(t, "id-1", out.ID)
	assert.Equal(t, "タイトル", out.JapaneseTitle)
	assert.Equal(t, "本文", out.JapaneseBody)
	assert.Equal(t, "2026-09-24T00:00:00Z", out.PublishedAt)
}

func TestConvertToOutputNoticesKeepsOrder(t *testing.T) {
	notices := []database.Notice{
		{ID: "a", PublishedAt: "2026-09-24T00:00:00Z"},
		{ID: "b", PublishedAt: "2026-09-23T00:00:00Z"},
	}

	out := convertToOutputNotices(notices)

	assert.Len(t, out, 2)
	assert.Equal(t, "a", out[0].ID)
	assert.Equal(t, "b", out[1].ID)
}

func TestConvertToOutputNoticesEmpty(t *testing.T) {
	out := convertToOutputNotices([]database.Notice{})
	assert.NotNil(t, out)
	assert.Len(t, out, 0)
}

func TestConvertToFileNotice(t *testing.T) {
	notice := database.Notice{
		ID:            "id-1",
		EnglishTitle:  "Title",
		JapaneseTitle: "タイトル",
		EnglishBody:   "Body",
		JapaneseBody:  "本文",
		PublishedAt:   "2026-09-24T00:00:00Z",
		// createdAt / updatedAt は配信用 JSON には含めない
		CreatedAt: "2026-09-01T00:00:00Z",
		UpdatedAt: "2026-09-02T00:00:00Z",
	}

	f := convertToFileNotice(notice)

	assert.Equal(t, "id-1", f.ID)
	assert.Equal(t, "Title", f.EnglishTitle)
	assert.Equal(t, "2026-09-24T00:00:00Z", f.PublishedAt)
}
