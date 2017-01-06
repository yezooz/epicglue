package middleware

import (
	"github.com/codegangsta/cli"

	"github.com/gin-gonic/gin"
	"github.com/uber-go/zap"
	"github.com/yezooz/epicglue/api/store"
	"github.com/yezooz/epicglue/api/store/datastore"
)

var log = zap.New(zap.NewTextEncoder())

// Store is a middleware function that initializes the Datastore and attaches to
// the context of every http.Request.

// helper function to create the datastore from the CLI context.
func Store(cli *cli.Context) gin.HandlerFunc {
	v := setupStore()
	return func(c *gin.Context) {
		store.ToContext(c, v)
		c.Next()
	}
}

func setupStore() store.Store {
	return datastore.New(
		"postgres",
		"host=127.0.0.1 user=epic password=epic dbname=epic sslmode=disable",
	)
}
