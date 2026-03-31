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

type Question struct {
	Service service.Question
	APIKey  string
}

func (q *Question) ListQuestionGet(c echo.Context) error {
	questions, err := q.Service.GetQuestions()
	if err != nil {
		slog.Error(err.Error())
		res := response.Message{Message: "Error!"}
		return c.JSON(http.StatusInternalServerError, res)
	}

	res := response.GetQuestions{
		Questions: convertToResponseQuestions(questions),
	}
	return c.JSON(http.StatusOK, res)
}

func (q *Question) GetQuestionGet(c echo.Context) error {
	id := c.Param("id")
	in := input.GetQuestion{
		ID: id,
	}
	question, err := q.Service.GetQuestion(in)
	if err != nil {
		slog.Error(err.Error())
		res := response.Message{Message: "Error!"}
		return c.JSON(http.StatusInternalServerError, res)
	}

	res := convertToResponseQuestion(question)
	return c.JSON(http.StatusOK, res)
}

func (q *Question) AddQuestionPost(c echo.Context) error {
	authHeader := c.Request().Header.Get("Authorization")
	err := checkAuthHeader(authHeader, q.APIKey)
	if err != nil {
		res := response.Message{Message: "Error!"}
		return c.JSON(http.StatusForbidden, res)
	}

	req := new(request.AddQuestion)
	if err := c.Bind(&req); err != nil {
		slog.Error(err.Error())
		res := response.Message{Message: "Failed to parse request"}
		return c.JSON(http.StatusInternalServerError, res)
	}

	in := input.AddQuestion{
		ProblemImageNames:  req.ProblemImageNames,
		SolutionImageNames: req.SolutionImageNames,
		References:         req.References,
	}
	err = q.Service.AddQuestion(in)
	if err != nil {
		slog.Error(err.Error())
		res := response.Message{Message: "Error!"}
		return c.JSON(http.StatusInternalServerError, res)
	}

	res := response.Message{Message: "Success!!"}
	return c.JSON(http.StatusOK, res)
}

func (q *Question) EditQuestionPost(c echo.Context) error {
	authHeader := c.Request().Header.Get("Authorization")
	err := checkAuthHeader(authHeader, q.APIKey)
	if err != nil {
		res := response.Message{Message: "Error!"}
		return c.JSON(http.StatusForbidden, res)
	}

	req := new(request.EditQuestion)
	if err := c.Bind(&req); err != nil {
		slog.Error(err.Error())
		res := response.Message{Message: "Failed to parse request"}
		return c.JSON(http.StatusInternalServerError, res)
	}

	in := input.EditQuestion{
		ID:                 req.ID,
		ProblemImageNames:  req.ProblemImageNames,
		SolutionImageNames: req.SolutionImageNames,
		References:         req.References,
	}
	err = q.Service.EditQuestion(in)
	if err != nil {
		slog.Error(err.Error())
		res := response.Message{Message: "Error!"}
		return c.JSON(http.StatusInternalServerError, res)
	}

	res := response.Message{Message: "Success!!"}
	return c.JSON(http.StatusOK, res)
}

func (q *Question) DeleteQuestionDelete(c echo.Context) error {
	authHeader := c.Request().Header.Get("Authorization")
	err := checkAuthHeader(authHeader, q.APIKey)
	if err != nil {
		res := response.Message{Message: "Error!"}
		return c.JSON(http.StatusForbidden, res)
	}

	req := new(request.DeleteQuestion)
	if err := c.Bind(&req); err != nil {
		slog.Error(err.Error())
		res := response.Message{Message: "Failed to parse request"}
		return c.JSON(http.StatusInternalServerError, res)
	}

	in := input.DeleteQuestion{
		ID: req.ID,
	}
	err = q.Service.DeleteQuestion(in)
	if err != nil {
		slog.Error(err.Error())
		res := response.Message{Message: "Error!"}
		return c.JSON(http.StatusInternalServerError, res)
	}

	res := response.Message{Message: "Success!!"}
	return c.JSON(http.StatusOK, res)
}
