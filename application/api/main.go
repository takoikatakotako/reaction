package main

import (
	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
	"github.com/takoikatakotako/reaction/api/handler"
	"github.com/takoikatakotako/reaction/api/service"
	"github.com/takoikatakotako/reaction/environment"
	"github.com/takoikatakotako/reaction/infrastructure"
)

func main() {
	// environment
	env := environment.Environment{}
	env.SetReactionAWSProfile("local")
	env.SetResourceBaseURL("http://localhost:4566")
	env.SetResourceBucketName("xxxx")

	// infrastructure
	awsRepository := infrastructure.AWS{
		Profile: env.Profile,
	}

	// service
	reactionService := service.Reaction{
		AWS:                awsRepository,
		ResourceBucketName: env.ResourceBucketName,
		ResourceBaseURL:    env.ResourceBaseURL,
	}

	// handler
	healthcheckHandler := handler.Healthcheck{}
	reactionHandler := handler.Reaction{
		Service: reactionService,
	}

	e := echo.New()
	e.Use(middleware.Logger())

	// healthcheck
	e.GET("/api/healthcheck", healthcheckHandler.HealthcheckGet)

	// reaction
	e.GET("/api/reaction/list", reactionHandler.ListReactionGet)
	e.GET("/api/reaction/detail/:id", reactionHandler.GetReactionGet)
	e.POST("/api/reaction/add", reactionHandler.AddReactionPost)
	e.POST("/api/reaction/edit/:id", reactionHandler.EditReactionPost)
	e.DELETE("/api/reaction/edit/:id", reactionHandler.DeleteReactionDelete)

	e.Logger.Fatal(e.Start(":8080"))
}
