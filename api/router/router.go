package router

import (
	"net/http"

	"github.com/gin-gonic/gin"

	"github.com/drone/drone-ui/dist"
	"github.com/yezooz/epicglue/api/router/middleware/header"
	"github.com/yezooz/epicglue/api/server"
	"github.com/yezooz/epicglue/api/server/template"
)

// Load loads the router
func Load(middleware ...gin.HandlerFunc) http.Handler {

	e := gin.New()
	e.Use(gin.Recovery())

	e.SetHTMLTemplate(template.Load())

	fs := http.FileServer(dist.AssetFS())
	e.GET("/static/*filepath", func(c *gin.Context) {
		fs.ServeHTTP(c.Writer, c.Request)
	})

	e.Use(header.NoCache)
	e.Use(header.Options)
	e.Use(header.Secure)
	e.Use(middleware...)
	//e.Use(session.SetUser())
	//e.Use(token.Refresh)

	e.NoRoute(server.ShowIndex)

	api := e.Group("/v1")

	bucket := api.Group("/buckets")
	{
		//bucket.Use(session.MustUser())
		bucket.GET("", server.GetBuckets)
		bucket.GET("/:id", server.GetBucket)
		bucket.PUT("", server.CreateBucket)
		bucket.POST("/:id", server.UpdateBucket)
		bucket.DELETE("/:id", server.DeleteBucket)
	}

	return e
}
