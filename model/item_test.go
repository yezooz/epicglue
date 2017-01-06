package model_test

import (
	"database/sql"
	"fmt"
	"github.com/uber-go/zap"
	"github.com/yezooz/epicglue/model"
	"github.com/yezooz/meddler"
	"testing"
)

var log = zap.New(zap.NewTextEncoder())

func open(driver, config string) *sql.DB {
	db, err := sql.Open(driver, config)
	if err != nil {
		log.Error(err.Error())
		log.Fatal("database connection failed")
	}

	meddler.Default = meddler.PostgreSQL

	//if err := pingDatabase(db); err != nil {
	//	log.Error(err)
	//	log.Fatal("database ping attempts failed")
	//}

	//if err := setupDatabase(driver, db); err != nil {
	//	logrus.Errorln(err)
	//	logrus.Fatalln("migration failed")
	//}
	//cleanupDatabase(db)

	return db
}

func TestBasicInsert(t *testing.T) {
	db := open("postgres")
	i := model.Item{}

	err := meddler.Insert(db, "item", &i)

	fmt.Println(err)
}
