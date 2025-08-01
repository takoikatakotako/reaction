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

type Reaction struct {
	Service service.Reaction
	APIKey  string
}

func (a *Reaction) ListReactionGet(c echo.Context) error {
	reactions, err := a.Service.GetReactions()
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

func (a *Reaction) GetReactionGet(c echo.Context) error {
	id := c.Param("id")
	in := input.GetReaction{
		ID: id,
	}
	reaction, err := a.Service.GetReaction(in)
	if err != nil {
		slog.Error(err.Error())
		res := response.Message{Message: "Error!"}
		return c.JSON(http.StatusInternalServerError, res)
	}

	res := convertToResponseReaction(reaction)
	return c.JSON(http.StatusOK, res)
}

func (a *Reaction) AddReactionPost(c echo.Context) error {
	// Check Auth Header
	authHeader := c.Request().Header.Get("Authorization")
	err := checkAuthHeader(authHeader, a.APIKey)
	if err != nil {
		res := response.Message{Message: "Error!"}
		return c.JSON(http.StatusForbidden, res)
	}

	// parse request
	req := new(request.AddReaction)
	if err := c.Bind(&req); err != nil {
		slog.Error(err.Error())
		res := response.Message{Message: "Failed to parse request"}
		return c.JSON(http.StatusInternalServerError, res)
	}

	in := input.AddReaction{
		EnglishName:              req.EnglishName,
		JapaneseName:             req.JapaneseName,
		ThumbnailImageName:       req.ThumbnailImageName,
		GeneralFormulaImageNames: req.GeneralFormulaImageNames,
		MechanismsImageNames:     req.MechanismsImageNames,
		ExampleImageNames:        req.ExampleImageNames,
		SupplementsImageNames:    req.SupplementsImageNames,
		Suggestions:              req.Suggestions,
		Reactants:                req.Reactants,
		Products:                 req.Products,
		YoutubeUrls:              req.YoutubeUrls,
	}
	err = a.Service.AddReaction(in)
	if err != nil {
		slog.Error(err.Error())
		res := response.Message{Message: "Error!"}
		return c.JSON(http.StatusInternalServerError, res)
	}

	res := response.Message{Message: "Success!!"}
	return c.JSON(http.StatusOK, res)
}

func (a *Reaction) EditReactionPost(c echo.Context) error {
	// Check Auth Header
	authHeader := c.Request().Header.Get("Authorization")
	err := checkAuthHeader(authHeader, a.APIKey)
	if err != nil {
		res := response.Message{Message: "Error!"}
		return c.JSON(http.StatusForbidden, res)
	}

	// parse request
	req := new(request.EditReaction)
	if err := c.Bind(&req); err != nil {
		slog.Error(err.Error())
		res := response.Message{Message: "Failed to parse request"}
		return c.JSON(http.StatusInternalServerError, res)
	}

	in := input.EditReaction{
		ID:                       req.ID,
		EnglishName:              req.EnglishName,
		JapaneseName:             req.JapaneseName,
		ThumbnailImageName:       req.ThumbnailImageName,
		GeneralFormulaImageNames: req.GeneralFormulaImageNames,
		MechanismsImageNames:     req.MechanismsImageNames,
		ExampleImageNames:        req.ExampleImageNames,
		SupplementsImageNames:    req.SupplementsImageNames,
		Suggestions:              req.Suggestions,
		Reactants:                req.Reactants,
		Products:                 req.Products,
		YoutubeUrls:              req.YoutubeUrls,
	}
	err = a.Service.EditReaction(in)
	if err != nil {
		slog.Error(err.Error())
		res := response.Message{Message: "Error!"}
		return c.JSON(http.StatusInternalServerError, res)
	}

	res := response.Message{Message: "Success!!"}
	return c.JSON(http.StatusOK, res)
}

func (a *Reaction) DeleteReactionDelete(c echo.Context) error {
	// Check Auth Header
	authHeader := c.Request().Header.Get("Authorization")
	err := checkAuthHeader(authHeader, a.APIKey)
	if err != nil {
		res := response.Message{Message: "Error!"}
		return c.JSON(http.StatusForbidden, res)
	}

	// parse request
	req := new(request.DeleteReaction)
	if err := c.Bind(&req); err != nil {
		slog.Error(err.Error())
		res := response.Message{Message: "Failed to parse request"}
		return c.JSON(http.StatusInternalServerError, res)
	}

	in := input.DeleteReaction{
		ID: req.ID,
	}
	err = a.Service.DeleteReaction(in)
	if err != nil {
		slog.Error(err.Error())
		res := response.Message{Message: "Error!"}
		return c.JSON(http.StatusInternalServerError, res)
	}

	res := response.Message{Message: "Success!!"}
	return c.JSON(http.StatusOK, res)
}

func (a *Reaction) GenerateReactionPost(c echo.Context) error {
	// Check Auth Header
	authHeader := c.Request().Header.Get("Authorization")
	err := checkAuthHeader(authHeader, a.APIKey)
	if err != nil {
		res := response.Message{Message: "Error!"}
		return c.JSON(http.StatusForbidden, res)
	}

	err = a.Service.GenerateReactions()
	if err != nil {
		slog.Error(err.Error())
		res := response.Message{Message: "Error!"}
		return c.JSON(http.StatusInternalServerError, res)
	}

	res := response.Message{Message: "Success!!"}
	return c.JSON(http.StatusOK, res)
}
