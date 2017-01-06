package model_test

import (
	"fmt"
	"github.com/satori/go.uuid"
	"github.com/yezooz/epicglue/model"
	"github.com/yezooz/meddler"
	"testing"
	"time"
)

func TestBasicServiceInsert(t *testing.T) {
	db := setupStore()

	i := model.Service{
		ID:        uuid.NewV4(),
		CreatedAt: time.Now(),
	}

	err := meddler.Insert(db, "service", &i)

	if err != nil {
		fmt.Println(err.Error())
	}
}
