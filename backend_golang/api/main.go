package handler

import (
	"dee2509/wtb/internal/database"
	"dee2509/wtb/internal/routes"
	"net/http"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
)

var app *gin.Engine

func GetApp() *gin.Engine {
	// If app is already initialized, just return it
	if app != nil {
		return app
	}

	gin.SetMode(gin.ReleaseMode)
	r := gin.New()
	r.Use(gin.Recovery())
	r.Use(cors.Default())
	r.Use(gin.Logger())

	r.Use(cors.New(cors.Config{
		AllowOrigins:     []string{"*"}, // Allows your Flutter web app to talk to it
		AllowMethods:     []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"},
		AllowHeaders:     []string{"Origin", "Content-Type", "Accept"},
		ExposeHeaders:    []string{"Content-Length"},
		AllowCredentials: true,
	}))

	database.ConnectDB()
	routes.SetupRoutes(r)

	app = r // Assign the local 'r' to the global 'app'
	return app
}

// Handler MUST be capitalized and have exactly two parameters
func Handler(w http.ResponseWriter, r *http.Request) {
	engine := GetApp()
	engine.ServeHTTP(w, r)
}
