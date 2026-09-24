package infrastructure

import (
	"github.com/stretchr/testify/assert"
	"github.com/takoikatakotako/reaction/infrastructure/database"
	"testing"
)

func ids(notices []database.Notice) []string {
	result := make([]string, 0, len(notices))
	for _, notice := range notices {
		result = append(result, notice.ID)
	}
	return result
}

func TestSortNoticesByPublishedAtDesc(t *testing.T) {
	notices := []database.Notice{
		{ID: "old", PublishedAt: "2026-09-20T00:00:00Z"},
		{ID: "new", PublishedAt: "2026-09-24T00:00:00Z"},
		{ID: "mid", PublishedAt: "2026-09-22T00:00:00Z"},
	}

	sortNoticesByPublishedAtDesc(notices)

	assert.Equal(t, []string{"new", "mid", "old"}, ids(notices))
}

// オフセット付きの値が、文字列比較ではなく時刻として並ぶこと。
// "2026-09-24T01:00:00+09:00" は UTC では 2026-09-23T16:00:00Z なので
// "2026-09-23T20:00:00Z" より古い。辞書順だと逆になる。
func TestSortNoticesHandlesTimezoneOffsets(t *testing.T) {
	notices := []database.Notice{
		{ID: "jst", PublishedAt: "2026-09-24T01:00:00+09:00"},
		{ID: "utc", PublishedAt: "2026-09-23T20:00:00Z"},
	}

	sortNoticesByPublishedAtDesc(notices)

	assert.Equal(t, []string{"utc", "jst"}, ids(notices))
}

func TestSortNoticesHandlesFractionalSeconds(t *testing.T) {
	notices := []database.Notice{
		{ID: "a", PublishedAt: "2026-09-24T00:00:00.100Z"},
		{ID: "b", PublishedAt: "2026-09-24T00:00:00.900Z"},
	}

	sortNoticesByPublishedAtDesc(notices)

	assert.Equal(t, []string{"b", "a"}, ids(notices))
}

// パースできない値は最後に回す
func TestSortNoticesPutsUnparsableLast(t *testing.T) {
	notices := []database.Notice{
		{ID: "broken", PublishedAt: "2026/09/24"},
		{ID: "valid", PublishedAt: "2026-09-20T00:00:00Z"},
		{ID: "empty", PublishedAt: ""},
	}

	sortNoticesByPublishedAtDesc(notices)

	assert.Equal(t, "valid", ids(notices)[0])
	assert.ElementsMatch(t, []string{"broken", "empty"}, ids(notices)[1:])
}

func TestSortNoticesEmptySlice(t *testing.T) {
	notices := []database.Notice{}
	sortNoticesByPublishedAtDesc(notices)
	assert.Empty(t, notices)
}
