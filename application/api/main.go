package main

import (
	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
	"github.com/takoikatakotako/reaction/api/handler"
	"github.com/takoikatakotako/reaction/environment"
	"os"
)

func getEnvironment(key string, defaultValue string) string {
	// 環境変数の値を取得
	val, exists := os.LookupEnv(key)
	if !exists {
		return defaultValue
	}
	return val
}

func main() {
	// environment
	env := environment.Environment{}
	env.SetReactionAWSProfile("local")
	env.SetResourceBaseURL("http://localhost:4566")

	// infrastructure
	//awsRepository := infrastructure.AWS{
	//	Profile: env.Profile,
	//}

	// service
	//userService := service.User{
	//	AWS: awsRepository,
	//}
	//alarmService := service.Alarm{
	//	AWS: awsRepository,
	//}
	//charaService := service.Chara{
	//	AWS:         awsRepository,
	//	Environment: env,
	//}
	//pushTokenService := service.PushToken{
	//	AWS: awsRepository,
	//}

	// handler
	healthcheckHandler := handler.Healthcheck{}
	reactionHandler := handler.Reaction{}
	//requireHandler := handler.Require{}
	//userHandler := handler.User{
	//	Service: userService,
	//}
	//alarmHandler := handler.Alarm{
	//	Service: alarmService,
	//}
	//charaHandler := handler.Chara{
	//	Service: charaService,
	//}
	//pushTokenHandler := handler.PushToken{
	//	Service: pushTokenService,
	//}
	//newsHandler := handler.News{}

	e := echo.New()
	e.Use(middleware.Logger())

	// healthcheck
	e.GET("/healthcheck", healthcheckHandler.HealthcheckGet)

	// reaction
	e.GET("/reaction/list", reactionHandler.ListReactionGet)
	e.GET("/reaction/detail/:id", reactionHandler.GetReactionGet)
	e.POST("/reaction/add", reactionHandler.AddReactionPost)
	e.POST("/reaction/edit/:id", reactionHandler.EditReactionPost)
	e.DELETE("/reaction/edit/:id", reactionHandler.DeleteReactionDelete)

	e.Logger.Fatal(e.Start(":8080"))
}
