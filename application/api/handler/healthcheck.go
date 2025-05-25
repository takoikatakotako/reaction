package handler

import (
	"github.com/labstack/echo/v4"
	"github.com/takoikatakotako/reaction/api/handler/response"
	"net/http"
)

type Healthcheck struct{}

func (h *Healthcheck) HealthcheckGet(c echo.Context) error {
	res := response.Message{
		Message: Healthy,
	}
	return c.JSON(http.StatusOK, res)
}
