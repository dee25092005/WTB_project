package handlers

import (
	"context"
	"dee2509/wtb/internal/database"
	"dee2509/wtb/internal/models"
	"dee2509/wtb/internal/service"
	"fmt"
	"net/http"
	"strings"

	"github.com/gin-gonic/gin"
)

func GetAllBans(c *gin.Context) {
	rows, err := database.Conn.Query(context.Background(), `SELECT id, name, district, coordinates, landmark_url FROM bans`)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	defer rows.Close()

	var bans []models.Ban
	for rows.Next() {
		var ban models.Ban
		err := rows.Scan(&ban.ID, &ban.Name, &ban.District, &ban.Coordinates, &ban.LandmarkURL)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		bans = append(bans, ban)
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Bans retrieved successfully",
		"status":  http.StatusOK,
		"data":    bans,
	})
}
func CreateBan(c *gin.Context) {
	var newBan models.Ban
	if err := c.ShouldBindJSON(&newBan); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	newBan.XPPoints = 100
	query := `INSERT INTO bans (name, district, coordinates, landmark_url,xp_points) 
	VALUES ($1, $2, $3, $4, $5) RETURNING id`

	err := database.Conn.QueryRow(context.Background(), query,
		newBan.Name, newBan.District, newBan.Coordinates, newBan.LandmarkURL, newBan.XPPoints).Scan(&newBan.ID)

	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message":  "Ban created successfully",
		"status":   http.StatusOK,
		"landmark": newBan.LandmarkURL,
		"xp_gain":  newBan.XPPoints,
		"data":     newBan,
	})
}

func GetUserStats(c *gin.Context) {
	var totalXp int
	var villageCount int
	query := `SELECT COALESCE(SUM(xp_points), 0) FROM bans`

	err := database.Conn.QueryRow(context.Background(), query).Scan(&totalXp)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	database.Conn.QueryRow(context.Background(), `SELECT COUNT(*) FROM bans`).Scan(&villageCount)

	level := (totalXp / 100) + 1
	c.JSON(200, gin.H{
		"status": http.StatusOK,
		"data": gin.H{
			"total_xp":       totalXp,
			"level":          level,
			"rank":           getRankName(level),
			"villages_connt": villageCount,
		},
	})
}

func getRankName(level int) string {
	if level <= -1 {
		return "Unranked"
	}
	if level < 5 {
		return "Novice"
	}
	if level < 10 {
		return "Apprentice"
	}
	if level < 20 {
		return "Adept"
	}
	if level < 30 {
		return "Expert"
	}
	if level < 40 {
		return "Master"
	}
	if level < 50 {
		return "Grandmaster"
	}

	return "Legendary"
}

func UpdateBan(c *gin.Context) {
	id := c.Param("id")

	var updateBan models.Ban

	//get update data
	if err := c.ShouldBindJSON(&updateBan); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	query := `UPDATE bans SET name = $1, district = $2, coordinates = $3, landmark_url = $4 WHERE id = $5`

	_, err := database.Conn.Exec(context.Background(), query, updateBan.Name, updateBan.District, updateBan.Coordinates, updateBan.LandmarkURL, id)

	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Ban updated successfully",
		"status":  http.StatusOK,
		"data":    updateBan,
	})
}
func DeleteBan(c *gin.Context) {
	id := c.Param("id")

	// 1. Get URL from DB
	var imageURL string
	err := database.Conn.QueryRow(context.Background(), "SELECT landmark_url FROM bans WHERE id = $1", id).Scan(&imageURL)

	// It's okay if we get an error (maybe ID doesn't exist), but handle it
	if err == nil && imageURL != "" {
		publicID := extractPublicID(imageURL)

		// --- DEBUG LOGGING (Check your terminal!) ---
		fmt.Printf("Original URL: %s\n", imageURL)
		fmt.Printf("Extracted ID: %s\n", publicID)
		// ---------------------------------------------

		err := service.DeleteImage(publicID)
		if err != nil {
			fmt.Printf("Cloudinary Delete Error: %v\n", err)
			// We continue anyway to delete the DB record
		}
	}

	// 2. Delete from DB
	query := "DELETE FROM bans WHERE id = $1"
	result, err := database.Conn.Exec(context.Background(), query, id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	rowsAffected := result.RowsAffected()
	if rowsAffected == 0 {
		c.JSON(http.StatusNotFound, gin.H{"error": "Village not found"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Village deleted successfully",
		"status":  http.StatusOK,
	})
}

func extractPublicID(url string) string {
	// 1. Split by "/upload/"
	parts := strings.Split(url, "/upload/")
	if len(parts) < 2 {
		return ""
	}

	// parts[1] is now "v123456/folder/subfolder/my_image.jpg"
	path := parts[1]

	// 2. Remove version prefix (e.g., "v123456/") if it exists
	// We split by "/" and if the first part starts with 'v' and is numeric, we skip it.
	pathParts := strings.Split(path, "/")
	if len(pathParts) > 0 && strings.HasPrefix(pathParts[0], "v") {
		// Rejoin everything AFTER the version
		path = strings.Join(pathParts[1:], "/")
	}

	// 3. Remove file extension (e.g., ".jpg")
	if dotIndex := strings.LastIndex(path, "."); dotIndex != -1 {
		path = path[:dotIndex]
	}

	return path
}
