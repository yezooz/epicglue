package test_helper

import (
	"fmt"
	"github.com/jinzhu/gorm"
	"github.com/jinzhu/gorm/dialects/postgres"
	"os"
	"strings"
)

func TestDBConnection(dbNameSuffix string) *gorm.DB {
	dbName := fmt.Sprintf("epicglue_test_%s", strings.ToLower(dbNameSuffix))

	db, err := gorm.Open("postgres", "host=localhost user=epic password=epic sslmode=disable port=5433")
	if err != nil {
		panic(fmt.Sprintf("No error should happen when connecting to test database, but got err=%+v", err))
	}
	_, err = db.DB().Exec(fmt.Sprintf("CREATE DATABASE %s OWNER epic", dbName))
	if err != nil {
		panic(fmt.Sprintf("No error should happen when creating database %s, but got err=%+v", dbName, err))
	}

	db, err = gorm.Open("postgres", fmt.Sprintf("host=localhost user=epic password=epic dbname=%s sslmode=disable port=5433", dbName))
	if err != nil {
		panic(fmt.Sprintf("No error should happen when connecting to %s database, but got err=%+v", dbName, err))
	}

	// db.SetLogger(Logger{log.New(os.Stdout, "\r\n", 0)})
	// db.SetLogger(log.New(os.Stdout, "\r\n", 0))
	if os.Getenv("DEBUG") == "true" {
		db.LogMode(true)
	}

	db.DB().SetMaxIdleConns(10)

	return db
}

func HasRecordsInTable(tableName string) bool {
	var count int

	postgres.NewPostgres().DB().QueryRow(fmt.Sprintf(`
		SELECT
			COUNT(*) AS c
		FROM
			"%s"
	`, tableName)).Scan(&count)

	return count > 0
}

func HasRecordsInTableWithCondition(tableName string, condition string) bool {
	var count int

	query := fmt.Sprintf(`
		SELECT
			COUNT(*) AS c
		FROM
			"%s"
		WHERE
			%s
	`, tableName, condition)

	postgres.NewPostgres().DB().QueryRow(query).Scan(&count)

	return count > 0
}
