package database

import (
	"context"
	"fmt"
	"log"
	"os"

	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/joho/godotenv"
)

var Conn *pgxpool.Pool

func ConnectDB() {
_:
	godotenv.Load(".env")

	var err error

	connStr := os.Getenv("DATABASE_URL")
	if connStr == "" {
		fmt.Println("DATABASE_URL environment variable not set")
		log.Fatal("DATABASE_URL environment variable not set")
	}

	Conn, err = pgxpool.New(context.Background(), connStr)
	if err != nil {
		fmt.Println("Unable to create connection pool:", err)
		log.Fatalf("Unable to create connection pool: %v", err)
	}

	err = Conn.Ping(context.Background())
	if err != nil {
		fmt.Println("Database is unreachable:", err)
		log.Fatalf("Database is unreachable: %v", err)
	}

	fmt.Println("Successfully connected to the database pool!")

}
