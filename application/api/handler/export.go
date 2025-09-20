package handler

import (
	"github.com/labstack/echo/v4"
	"github.com/takoikatakotako/reaction/api/handler/response"
	"github.com/takoikatakotako/reaction/api/service"
	"log/slog"
	"net/http"
)

type Export struct {
	Service service.Export
	APIKey  string
}

func (e *Export) ExportReactionsGet(c echo.Context) error {
	// Check Auth Header
	authHeader := c.Request().Header.Get("Authorization")
	err := checkAuthHeader(authHeader, e.APIKey)
	if err != nil {
		res := response.Message{Message: "Error!"}
		return c.JSON(http.StatusForbidden, res)
	}

	reactions, err := e.Service.GetReactions()
	if err != nil {
		slog.Error(err.Error())
		res := response.Message{Message: "Error!"}
		return c.JSON(http.StatusInternalServerError, res)
	}

	res := response.GetReactions{
		Reactions: convertToResponseReactions(reactions),
	}
	return c.JSON(http.StatusOK, res)
}

func (e *Export) ExportS3Post(c echo.Context) error {
	// Check Auth Header
	authHeader := c.Request().Header.Get("Authorization")
	err := checkAuthHeader(authHeader, e.APIKey)
	if err != nil {
		res := response.Message{Message: "Error!"}
		return c.JSON(http.StatusForbidden, res)
	}

	err = e.Service.ExportReactionsToS3()
	if err != nil {
		slog.Error(err.Error())
		res := response.Message{Message: "Error!"}
		return c.JSON(http.StatusInternalServerError, res)
	}

	res := response.Message{Message: "Success!!"}
	return c.JSON(http.StatusOK, res)
}
