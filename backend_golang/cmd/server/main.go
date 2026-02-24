package main

import (
	"dee2509/wtb/internal/database"
	"fmt"
	"os"

	"dee2509/wtb/internal/routes"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
)

func main() {
	database.ConnectDB()
	defer database.Conn.Close()

	r := gin.Default()
	r.Use(cors.Default())
	// Setup routes
	routes.SetupRoutes(r)

	// err := godotenv.Load(".env")
	// if err != nil {
	// 	panic("Error loading .env file")
	// }
	port := ":" + os.Getenv("PORT")
	if port == ":" {
		port = ":8080"
	}
	fmt.Println("Server is running on port", port)
	r.Run(port)

}
