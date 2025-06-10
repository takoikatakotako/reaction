package handler

import (
	"encoding/json"
	"github.com/labstack/echo/v4"
	"github.com/stretchr/testify/assert"
	"net/http"
	"net/http/httptest"
	"testing"
)

func TestHealthcheck_HealthcheckGet(t *testing.T) {
	// Setup
	e := echo.New()
	req := httptest.NewRequest(http.MethodGet, "/healthcheck", nil)
	req.Header.Set(echo.HeaderContentType, echo.MIMEApplicationJSON)
	rec := httptest.NewRecorder()
	c := e.NewContext(req, rec)
	h := &Healthcheck{}

	// Assertions
	if assert.NoError(t, h.HealthcheckGet(c)) {
		assert.Equal(t, http.StatusOK, rec.Code)

		expected := map[string]string{"message": "Healthy"}
		var actual map[string]string
		err := json.Unmarshal(rec.Body.Bytes(), &actual)
		assert.NoError(t, err)
		assert.Equal(t, expected, actual)
	}
}
