package router

import (
	"net/http"

	"github.com/gin-gonic/gin"

	"github.com/yezooz/epicglue/api/router/middleware/header"
	"github.com/yezooz/epicglue/api/server"
)

// Load loads the router
func Load(middleware ...gin.HandlerFunc) http.Handler {

	e := gin.New()
	e.Use(gin.Recovery())

	//e.SetHTMLTemplate(template.Load())

	//fs := http.FileServer(dist.AssetFS())
	//e.GET("/static/*filepath", func(c *gin.Context) {
	//	fs.ServeHTTP(c.Writer, c.Request)
	//})

	e.Use(header.NoCache)
	e.Use(header.Options)
	e.Use(header.Secure)
	e.Use(middleware...)
	//e.Use(session.SetUser())
	//e.Use(token.Refresh)

	//e.GET("/login", server.ShowLogin)
	//e.GET("/login/form", server.ShowLoginForm)
	//e.GET("/logout", server.GetLogout)
	e.NoRoute(server.ShowIndex)

	//api := e.Group("/v1")

	//channel := api.Group("/channel")
	//{
	//channel.Use(session.MustUser())
	//channel.GET("/:id", server.GetFeed)
	//channel.GET("/repos", server.GetRepos)
	//channel.GET("/repos/remote", server.GetRemoteRepos)
	//channel.POST("/token", server.PostToken)
	//channel.DELETE("/token", server.DeleteToken)
	//}

	return e
}
