package token

import (
	"time"

	log "github.com/Sirupsen/logrus"
	"github.com/gin-gonic/gin"
	"github.com/yezooz/epicglue/api/router/middleware/session"
	"github.com/yezooz/epicglue/api/store"
)

func Refresh(c *gin.Context) {
	user := session.User(c)
	if user == nil {
		c.Next()
		return
	}

	// check to see if the user token is expired or
	// will expire within the next 30 minutes (1800 seconds).
	// If not, there is nothing we really need to do here.
	if time.Now().UTC().Unix() < (user.Expiry - 1800) {
		c.Next()
		return
	}

	// attempts to refresh the access token. If the
	// token is refreshed, we must also persist to the
	// database.
	ok, _ = refresher.Refresh(user)
	if ok {
		err := store.UpdateUser(c, user)
		if err != nil {
			// we only log the error at this time. not sure
			// if we really want to fail the request, do we?
			log.Errorf("cannot refresh access token for %s. %s", user.Login, err)
		} else {
			log.Infof("refreshed access token for %s", user.Login)
		}
	}

	c.Next()
}
