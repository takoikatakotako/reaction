package handler

import (
	"github.com/labstack/echo/v4"
	"github.com/takoikatakotako/reaction/api/handler/response"
	"github.com/takoikatakotako/reaction/api/service"
	"net/http"
)

type Chara struct {
	Service service.Chara
}

func (chara *Chara) CharaListGet(c echo.Context) error {
	res, err := chara.Service.GetCharaList()
	if err != nil {
		res := response.Message{Message: "Error!"}
		return c.JSON(http.StatusInternalServerError, res)
	}
	return c.JSON(http.StatusOK, res)
}

func (chara *Chara) CharaIDGet(c echo.Context) error {
	charaID := c.Param("charaID")
	res, err := chara.Service.GetChara(charaID)
	if err != nil {
		res := response.Message{Message: "Error!"}
		return c.JSON(http.StatusInternalServerError, res)
	}
	return c.JSON(http.StatusOK, res)
}
