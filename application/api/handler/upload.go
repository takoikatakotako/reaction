package handler

import (
	"github.com/labstack/echo/v4"
	"github.com/takoikatakotako/reaction/api/handler/request"
	"github.com/takoikatakotako/reaction/api/handler/response"
	"github.com/takoikatakotako/reaction/api/service"
	"github.com/takoikatakotako/reaction/api/service/input"
	"net/http"
)

type Upload struct {
	Service service.Upload
}

func (a *Upload) GenerateUploadURLPost(c echo.Context) error {
	// parse request
	req := new(request.GenerateUploadURL)
	if err := c.Bind(&req); err != nil {
		res := response.Message{Message: "Failed to parse request"}
		return c.JSON(http.StatusInternalServerError, res)
	}

	in := input.GenerateUploadURL{
		ImageName: req.ImageName,
	}
	uploadURL, err := a.Service.GenerateUploadURLPost(in)
	if err != nil {
		res := response.Message{Message: "Error!"}
		return c.JSON(http.StatusInternalServerError, res)
	}

	res := response.UploadURL{
		UploadURL: uploadURL.UploadURL,
	}
	return c.JSON(http.StatusOK, res)
}
