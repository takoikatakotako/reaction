package handler

import (
	"github.com/labstack/echo/v4"
	request2 "github.com/takoikatakotako/reaction/api/handler/request"
	"github.com/takoikatakotako/reaction/api/handler/response"
	"github.com/takoikatakotako/reaction/api/service"
	"github.com/takoikatakotako/reaction/api/service/input"
	"net/http"
)

type Reaction struct {
	Service service.Reaction
}

func (a *Reaction) ListReactionGet(c echo.Context) error {
	reactions, err := a.Service.GetReactions()
	if err != nil {
		res := response.Message{Message: "Error!"}
		return c.JSON(http.StatusInternalServerError, res)
	}

	res := response.GetReactions{
		Reactions: convertToResponseReactions(reactions),
	}
	return c.JSON(http.StatusOK, res)
}

func (a *Reaction) GetReactionGet(c echo.Context) error {
	in := input.GetReaction{}
	res, err := a.Service.GetReaction(in)
	if err != nil {
		res := response.Message{Message: "Error!"}
		return c.JSON(http.StatusInternalServerError, res)
	}
	return c.JSON(http.StatusOK, res)
}

func (a *Reaction) AddReactionPost(c echo.Context) error {
	// parse request
	req := new(request2.AddReaction)
	if err := c.Bind(&req); err != nil {
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
	err := a.Service.AddReaction(in)
	if err != nil {
		res := response.Message{Message: "Error!"}
		return c.JSON(http.StatusInternalServerError, res)
	}

	res := response.Message{Message: "Success!!"}
	return c.JSON(http.StatusOK, res)
}

func (a *Reaction) EditReactionPost(c echo.Context) error {
	in := input.EditReaction{}
	err := a.Service.EditReaction(in)
	if err != nil {
		res := response.Message{Message: "Error!"}
		return c.JSON(http.StatusInternalServerError, res)
	}

	res := response.Message{Message: "Success!!"}
	return c.JSON(http.StatusOK, res)
}

func (a *Reaction) DeleteReactionDelete(c echo.Context) error {
	in := input.DeleteReaction{}
	err := a.Service.DeleteReaction(in)
	if err != nil {
		res := response.Message{Message: "Error!"}
		return c.JSON(http.StatusInternalServerError, res)
	}

	res := response.Message{Message: "Success!!"}
	return c.JSON(http.StatusOK, res)
}
