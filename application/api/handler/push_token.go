package handler

import (
	"github.com/labstack/echo/v4"
	"github.com/takoikatakotako/reaction/api/handler/auth"
	"github.com/takoikatakotako/reaction/api/handler/request"
	"github.com/takoikatakotako/reaction/api/handler/response"
	"github.com/takoikatakotako/reaction/api/service"
	"net/http"
)

type PushToken struct {
	Service service.PushToken
}

func (p *PushToken) PushTokenPushAdd(c echo.Context) error {
	authorizationHeader := c.Request().Header.Get("Authorization")
	userID, authToken, err := auth.Basic(authorizationHeader)
	if err != nil {
		res := response.Message{Message: "Error!"}
		return c.JSON(http.StatusInternalServerError, res)
	}

	req := new(request.AddPushTokenRequest)
	if err := c.Bind(&req); err != nil {
		res := response.Message{Message: "Error!"}
		return c.JSON(http.StatusInternalServerError, res)
	}

	err = p.Service.AddIOSPushToken(userID, authToken, req.PushToken)
	if err != nil {
		res := response.Message{Message: "Error!"}
		return c.JSON(http.StatusInternalServerError, res)
	}

	res := response.Message{
		Message: "Hello!",
	}
	return c.JSON(http.StatusOK, res)
}

func (p *PushToken) PushTokenVoIPPushAdd(c echo.Context) error {
	authorizationHeader := c.Request().Header.Get("Authorization")
	userID, authToken, err := auth.Basic(authorizationHeader)
	if err != nil {
		res := response.Message{Message: "Error!"}
		return c.JSON(http.StatusInternalServerError, res)
	}

	req := new(request.AddPushTokenRequest)
	if err := c.Bind(&req); err != nil {
		res := response.Message{Message: "Error!"}
		return c.JSON(http.StatusInternalServerError, res)
	}

	err = p.Service.AddIOSVoipPushToken(userID, authToken, req.PushToken)
	if err != nil {
		res := response.Message{Message: "Error!"}
		return c.JSON(http.StatusInternalServerError, res)
	}

	res := response.Message{
		Message: "Hello!",
	}
	return c.JSON(http.StatusOK, res)
}
