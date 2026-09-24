package handler

import (
	"encoding/json"
	"github.com/labstack/echo/v4"
	"github.com/stretchr/testify/assert"
	responsepkg "github.com/takoikatakotako/reaction/api/handler/response"
	"github.com/takoikatakotako/reaction/api/service/output"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"
)

const testAPIKey = "test-api-key"

func newNoticeContext(method string, body string, authHeader string) (echo.Context, *httptest.ResponseRecorder) {
	e := echo.New()
	req := httptest.NewRequest(method, "/api/notice", strings.NewReader(body))
	req.Header.Set(echo.HeaderContentType, echo.MIMEApplicationJSON)
	if authHeader != "" {
		req.Header.Set("Authorization", authHeader)
	}
	rec := httptest.NewRecorder()
	return e.NewContext(req, rec), rec
}

// 書き込み系は API キーが無い場合に 401 を返す
func TestNoticeWriteEndpointsRequireAuth(t *testing.T) {
	handler := &Notice{APIKey: testAPIKey}

	cases := []struct {
		name   string
		method string
		body   string
		call   func(echo.Context) error
	}{
		{"add", http.MethodPost, `{"japaneseTitle":"お知らせ"}`, handler.AddNoticePost},
		{"edit", http.MethodPost, `{"id":"abc"}`, handler.EditNoticePost},
		{"delete", http.MethodDelete, `{"id":"abc"}`, handler.DeleteNoticeDelete},
	}

	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			c, rec := newNoticeContext(tc.method, tc.body, "")
			if assert.NoError(t, tc.call(c)) {
				assert.Equal(t, http.StatusUnauthorized, rec.Code)
			}
		})
	}
}

// 誤った API キーでも 401 を返す
func TestNoticeWriteEndpointsRejectWrongKey(t *testing.T) {
	handler := &Notice{APIKey: testAPIKey}

	c, rec := newNoticeContext(http.MethodPost, `{"japaneseTitle":"お知らせ"}`, "Bearer wrong-key")
	if assert.NoError(t, handler.AddNoticePost(c)) {
		assert.Equal(t, http.StatusUnauthorized, rec.Code)
	}
}

func TestConvertToResponseNotice(t *testing.T) {
	res := convertToResponseNotice(output.Notice{
		ID:            "id-1",
		EnglishTitle:  "Maintenance",
		JapaneseTitle: "メンテナンスのお知らせ",
		EnglishBody:   "We will perform maintenance.",
		JapaneseBody:  "メンテナンスを行います。",
		PublishedAt:   "2026-09-24T00:00:00Z",
	})

	assert.Equal(t, "id-1", res.ID)
	assert.Equal(t, "メンテナンスのお知らせ", res.JapaneseTitle)
	assert.Equal(t, "Maintenance", res.EnglishTitle)
	assert.Equal(t, "2026-09-24T00:00:00Z", res.PublishedAt)
}

func TestConvertToResponseNoticesEmptyIsNotNull(t *testing.T) {
	// JSON で null ではなく [] になることを担保する
	res := toJSON(GetNoticesFixture())
	assert.Equal(t, `{"notices":[]}`, res)
}

func GetNoticesFixture() responsepkg.GetNotices {
	return responsepkg.GetNotices{Notices: convertToResponseNotices([]output.Notice{})}
}

func toJSON(v interface{}) string {
	b, _ := json.Marshal(v)
	return string(b)
}
