package routes

// This file defines the API routes for the application.

import (
	"dee2509/wtb/internal/handlers"

	"github.com/gin-gonic/gin"
)

func SetupRoutes(router *gin.Engine) {
	//group routes
	api := router.Group("/api")
	router.GET("/", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"status": "Server is running!!",
		})
	})

	api.GET("/ping", func(c *gin.Context) {

		c.JSON(200, gin.H{
			"message": "pong",
		})
	})
	api.POST("/ban", handlers.CreateBan)
	api.PUT("/ban/:id", handlers.UpdateBan)
	api.GET("/ban", handlers.GetAllBans)
	api.DELETE("/ban/:id", handlers.DeleteBan)

	//user
	router.GET("/user/stats", handlers.GetUserStats)

}
