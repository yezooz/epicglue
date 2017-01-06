package middleware

import (
	"github.com/gin-gonic/gin"
	"github.com/yezooz/epicglue/api/version"
)

// Version is a middleware function that appends the EpicGlue version information
// to the HTTP response. This is intended for debugging and troubleshooting.
func Version(c *gin.Context) {
	c.Header("X-EPICGLUE-VERSION", version.Version)
}
