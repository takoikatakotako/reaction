package handler

import (
	"github.com/labstack/echo/v4"
	"github.com/takoikatakotako/reaction/api/handler/response"
	"net/http"
)

type Require struct{}

func (r *Require) RequireGet(c echo.Context) error {
	res := response.Require{
		IOSVersion: "3.0.0",
	}
	return c.JSON(http.StatusOK, res)
}
