package store_db_postgres

import (
	"github.com/jinzhu/gorm"
	"gitlab.com/epicglue/epicglue/app/connection/database/postgres"
	"gitlab.com/epicglue/epicglue/app/helpers"
)

var log = helpers.GetLogger("worker_store")

type PostgresStore struct {
	Connection *gorm.DB
}

func NewPostgresStore() *PostgresStore {
	return &PostgresStore{
		Connection: postgres.NewPostgres(),
	}
}

func NewTestPostgresItemStore() *PostgresStore {
	// TODO: connect to test db, provision if needed
	return &PostgresStore{
		Connection: postgres.NewPostgres(),
	}
}

func (db PostgresStore) ItemsToProcess(tasks chan *worker_model.Task, params ...int) {
	panic("Doesn't work with Postgres")
}
