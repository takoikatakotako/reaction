package handler

import (
	"github.com/labstack/echo/v4"
	"github.com/takoikatakotako/reaction/api/handler/request"
	"github.com/takoikatakotako/reaction/api/handler/response"
	"github.com/takoikatakotako/reaction/api/service"
	"github.com/takoikatakotako/reaction/api/service/input"
	"log/slog"
	"net/http"
)

type Notice struct {
	Service service.Notice
	APIKey  string
}

func (n *Notice) ListNoticeGet(c echo.Context) error {
	notices, err := n.Service.GetNotices()
	if err != nil {
		slog.Error(err.Error())
		res := response.Message{Message: "Error!"}
		return c.JSON(http.StatusInternalServerError, res)
	}

	res := response.GetNotices{
		Notices: convertToResponseNotices(notices),
	}
	return c.JSON(http.StatusOK, res)
}

func (n *Notice) GetNoticeGet(c echo.Context) error {
	in := input.GetNotice{ID: c.Param("id")}
	notice, err := n.Service.GetNotice(in)
	if err != nil {
		slog.Error(err.Error())
		res := response.Message{Message: "Error!"}
		return c.JSON(http.StatusInternalServerError, res)
	}

	return c.JSON(http.StatusOK, convertToResponseNotice(notice))
}

func (n *Notice) AddNoticePost(c echo.Context) error {
	if err := checkAuthHeader(c.Request().Header.Get("Authorization"), n.APIKey); err != nil {
		res := response.Message{Message: "Error!"}
		return c.JSON(http.StatusUnauthorized, res)
	}

	req := new(request.AddNotice)
	if err := c.Bind(&req); err != nil {
		slog.Error(err.Error())
		res := response.Message{Message: "Failed to parse request"}
		return c.JSON(http.StatusInternalServerError, res)
	}

	in := input.AddNotice{
		EnglishTitle:  req.EnglishTitle,
		JapaneseTitle: req.JapaneseTitle,
		EnglishBody:   req.EnglishBody,
		JapaneseBody:  req.JapaneseBody,
		PublishedAt:   req.PublishedAt,
	}
	if err := n.Service.AddNotice(in); err != nil {
		slog.Error(err.Error())
		res := response.Message{Message: "Error!"}
		return c.JSON(http.StatusInternalServerError, res)
	}

	res := response.Message{Message: "Success!!"}
	return c.JSON(http.StatusOK, res)
}

func (n *Notice) EditNoticePost(c echo.Context) error {
	if err := checkAuthHeader(c.Request().Header.Get("Authorization"), n.APIKey); err != nil {
		res := response.Message{Message: "Error!"}
		return c.JSON(http.StatusUnauthorized, res)
	}

	req := new(request.EditNotice)
	if err := c.Bind(&req); err != nil {
		slog.Error(err.Error())
		res := response.Message{Message: "Failed to parse request"}
		return c.JSON(http.StatusInternalServerError, res)
	}

	in := input.EditNotice{
		ID:            req.ID,
		EnglishTitle:  req.EnglishTitle,
		JapaneseTitle: req.JapaneseTitle,
		EnglishBody:   req.EnglishBody,
		JapaneseBody:  req.JapaneseBody,
		PublishedAt:   req.PublishedAt,
	}
	if err := n.Service.EditNotice(in); err != nil {
		slog.Error(err.Error())
		res := response.Message{Message: "Error!"}
		return c.JSON(http.StatusInternalServerError, res)
	}

	res := response.Message{Message: "Success!!"}
	return c.JSON(http.StatusOK, res)
}

func (n *Notice) DeleteNoticeDelete(c echo.Context) error {
	if err := checkAuthHeader(c.Request().Header.Get("Authorization"), n.APIKey); err != nil {
		res := response.Message{Message: "Error!"}
		return c.JSON(http.StatusUnauthorized, res)
	}

	req := new(request.DeleteNotice)
	if err := c.Bind(&req); err != nil {
		slog.Error(err.Error())
		res := response.Message{Message: "Failed to parse request"}
		return c.JSON(http.StatusInternalServerError, res)
	}

	if err := n.Service.DeleteNotice(input.DeleteNotice{ID: req.ID}); err != nil {
		slog.Error(err.Error())
		res := response.Message{Message: "Error!"}
		return c.JSON(http.StatusInternalServerError, res)
	}

	res := response.Message{Message: "Success!!"}
	return c.JSON(http.StatusOK, res)
}
