package middleware

import (
	"github.com/codegangsta/cli"
	"github.com/gin-gonic/gin"
	"github.com/yezooz/epicglue/api/cache"
)

// Cache is a middleware function that initializes the Cache and attaches to
// the context of every http.Request.
func Cache(cli *cli.Context) gin.HandlerFunc {
	v := setupCache(cli)
	return func(c *gin.Context) {
		cache.ToContext(c, v)
	}
}

// helper function to create the cache from the CLI context.
func setupCache(c *cli.Context) cache.Cache {
	return cache.NewTTL(
		c.Duration("cache-ttl"),
	)
}
