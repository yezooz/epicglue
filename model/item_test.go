package model_test

import (
	"fmt"
	"github.com/satori/go.uuid"
	"github.com/uber-go/zap"
	"github.com/yezooz/epicglue/api/store"
	"github.com/yezooz/epicglue/api/store/datastore"
	"github.com/yezooz/epicglue/model"
	"github.com/yezooz/meddler"
	"testing"
	"time"
)

var log = zap.New(zap.NewTextEncoder())

func setupStore() store.Store {
	return datastore.New(
		"postgres",
		"host=127.0.0.1 user=epic password=epic dbname=epic sslmode=disable",
	)
}

func TestBasicInsert(t *testing.T) {
	db := setupStore()

	i := model.Item{
		ID:        uuid.NewV4(),
		CreatedAt: time.Now(),
	}

	err := meddler.Insert(db, "item", &i)

	if err != nil {
		fmt.Println(err.Error())
	}
}
