package server

import (
	"github.com/gin-gonic/gin"
)

func ShowIndex(c *gin.Context) {
	c.JSON(200, map[string]string{
		"status": "OK",
	})
}
