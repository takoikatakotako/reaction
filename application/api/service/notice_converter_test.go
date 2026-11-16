package service

import (
	"github.com/stretchr/testify/assert"
	"github.com/takoikatakotako/reaction/infrastructure/database"
	"github.com/takoikatakotako/reaction/infrastructure/file"
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

func TestConvertNoticeFillsTargetsForLegacyData(t *testing.T) {
	notice := database.Notice{ID: "id-1"}

	out := convertToOutputNotice(notice)
	assert.Equal(t, []string{"ios", "android"}, out.Platforms)
	assert.Equal(t, []string{"ja", "en"}, out.Languages)

	f := convertToFileNotice(notice)
	assert.Equal(t, []string{"ios", "android"}, f.Platforms)
	assert.Equal(t, []string{"ja", "en"}, f.Languages)
}

func TestConvertNoticeKeepsTargets(t *testing.T) {
	notice := database.Notice{ID: "id-1", Platforms: []string{"android"}, Languages: []string{"en"}}

	f := convertToFileNotice(notice)
	assert.Equal(t, []string{"android"}, f.Platforms)
	assert.Equal(t, []string{"en"}, f.Languages)
}

func noticeIDs(notices []file.Notice) []string {
	ids := make([]string, 0, len(notices))
	for _, n := range notices {
		ids = append(ids, n.ID)
	}
	return ids
}

func TestBuildNoticeFiles(t *testing.T) {
	notices := []database.Notice{
		{ID: "legacy"}, // 項目追加前のデータ = すべて対象
		{ID: "both", Platforms: []string{"ios", "android"}, Languages: []string{"ja", "en"}},
		{ID: "ios-only", Platforms: []string{"ios"}, Languages: []string{"ja", "en"}},
		{ID: "android-only", Platforms: []string{"android"}, Languages: []string{"ja", "en"}},
		{ID: "ios-ja-only", Platforms: []string{"ios"}, Languages: []string{"ja"}},
		{ID: "android-en-only", Platforms: []string{"android"}, Languages: []string{"en"}},
	}

	files := buildNoticeFiles(notices)

	assert.Len(t, files, 3)
	assert.Equal(t, []string{"legacy", "both", "ios-only", "ios-ja-only"}, noticeIDs(files["resource/notice/ios.json"]))
	assert.Equal(t, []string{"legacy", "both", "android-only", "android-en-only"}, noticeIDs(files["resource/notice/android.json"]))
	// 旧 iOS アプリ向けは片方の言語だけのお知らせを除く
	assert.Equal(t, []string{"legacy", "both", "ios-only"}, noticeIDs(files["resource/notice/list.json"]))
}

func TestBuildNoticeFilesEmpty(t *testing.T) {
	files := buildNoticeFiles([]database.Notice{})

	// お知らせが無くても空配列のファイルを出す（JSON が null にならないこと）
	for _, key := range []string{"resource/notice/ios.json", "resource/notice/android.json", "resource/notice/list.json"} {
		assert.NotNil(t, files[key], key)
		assert.Len(t, files[key], 0, key)
	}
}
