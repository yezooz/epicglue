package server

import (
	"fmt"
	"github.com/Sirupsen/logrus"
	"github.com/julienschmidt/httprouter"
	"github.com/yezooz/epicglue/api/server/endpoints"
	"github.com/yezooz/epicglue/common/config"
	"github.com/yezooz/epicglue/common/helpers"
	"net/http"
	"time"
)

const (
	APP_NAME = "Epic Glue"
	VERSION  = 1
)

var (
	log  = helpers.GetLogger("webserver")
	conf = config.LoadConfig()
)

func Run() {
	router := httprouter.New()

	//router.GET(getPath("items"), Log(Auth(Limit(GetItems()))))
	//router.PUT(getPath("items"), Log(Auth(Limit(AddItems))))
	//router.POST(getPath("items"), Log(Auth(Limit(UpdateItems))))
	//router.DELETE(getPath("items"), Log(Auth(DeleteItems)))
	//router.POST(getPath("items/count"), Log(Auth(Limit(Counters))))

	router.GET(getPath("channels"), Log(Auth(Limit(endpoints.GetChannels))))
	router.PUT(getPath("channel"), Log(Auth(Limit(endpoints.AddChannel))))
	router.POST(getPath("channel/:id"), Log(Auth(Limit(endpoints.UpdateChannel))))
	router.DELETE(getPath("channel/:id"), Log(Auth(Limit(endpoints.DeleteChannel))))

	router.GET(getPath("pipes"), Log(Auth(Limit(endpoints.GetPipe))))
	router.PUT(getPath("pipe"), Log(Auth(Limit(endpoints.AddPipe))))
	router.POST(getPath("pipe/:id"), Log(Auth(Limit(endpoints.UpdatePipe))))
	router.DELETE(getPath("pipe/:id"), Log(Auth(Limit(endpoints.DeletePipe))))

	//router.POST(getPath("login"), Log(LoginByEmail))
	//router.POST(getPath("register/email"), Log(RegisterByEmail))
	//router.POST(getPath("register/service"), Log(RegisterByService))
	//router.POST(getPath("register/device"), Log(RegisterByDevice))

	//router.GET(getPath("me"), Log(Auth(Me)))
	//router.POST(getPath("feedback"), Log(Auth(Feedback)))
	//router.PUT(getPath("me/service"), Log(Auth(ConnectService)))
	//router.DELETE(getPath("me/service"), Log(Auth(DisconnectService)))

	log.Info("Server starting...")

	log.Fatal(http.ListenAndServe(fmt.Sprintf(":%d", conf.App.Port), router))
}

func getPath(url string) string {
	return fmt.Sprintf("/v%d/%s", VERSION, url)
}

// Auth provides Token-based (JWT) auth
func Auth(h httprouter.Handle) httprouter.Handle {
	return func(w http.ResponseWriter, r *http.Request, ps httprouter.Params) {
		//    token, err := jwt.Parse(r.Header.Get("Token"), func(token *jwt.Token) (interface{}, error) {
		//        if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
		//            return nil, fmt.Errorf("Unexpected signing method: %v", token.Header["alg"])
		//        }
		//
		//        lookup := func(kind interface{}) (interface{}, error) {
		//            return []byte(conf.App.Secret), nil
		//        }
		//
		//        return lookup(token.Header["kind"])
		//    })
		//
		//    if err != nil {
		//        w.Header().Add("Content-type", "application/json")
		//        w.WriteHeader(http.StatusUnauthorized)
		//        w.Write([]byte(`{"error":"User Unknown", "code": 100}`))
		//        return
		//    }
		//
		//    if claims, ok := token.Claims.(jwt.MapClaims); ok && token.Valid {
		//        um := user_manager.NewDefaultUserManager(int64(claims["userId"].(float64)))
		//
		//        if um == nil {
		//            w.Header().Add("Content-type", "application/json")
		//            w.WriteHeader(http.StatusUnauthorized)
		//            w.Write([]byte(`{"error":"User Unknown", "code": 100}`))
		//            return
		//        }
		//
		//        if !um.IsTokenActive(token.Raw) {
		//            w.Header().Add("Content-type", "application/json")
		//            w.WriteHeader(http.StatusUnauthorized)
		//            //w.Write([]byte(`{"error":"Token Invalid", "code": 101}`))
		//            return
		//        }
		//
		//        // TODO: use context instead
		//        r.Header.Set("User", um.GetUser().Username)
		//        r.Header.Set("UserId", fmt.Sprintf("%d", um.GetUser().Id))
		//
		//        h(w, r, ps)
		//    } else {
		//        w.Header().Add("Content-type", "application/json")
		//        w.WriteHeader(http.StatusUnauthorized)
		//        w.Write([]byte(`{"error":"User Unknown", "code": 100}`))
		//    }
	}
}

func Public(h httprouter.Handle) httprouter.Handle {
	return func(w http.ResponseWriter, r *http.Request, ps httprouter.Params) {
		// extra logging
	}
}

// Only for internal use
func Private(h httprouter.Handle) httprouter.Handle {
	return func(w http.ResponseWriter, r *http.Request, ps httprouter.Params) {

	}
}

// Log sends each request to logger
func Log(h httprouter.Handle) httprouter.Handle {
	return func(w http.ResponseWriter, r *http.Request, ps httprouter.Params) {
		h(w, r, ps)

		log.WithFields(logrus.Fields{
			"method":   r.Method,
			"endpoint": r.URL.Path,
		}).Infof("%s %s", r.Method, r.URL.Path)
	}
}

// Limit does Rate-Limiting for endpoints
func Limit(h httprouter.Handle) httprouter.Handle {
	return func(w http.ResponseWriter, r *http.Request, ps httprouter.Params) {
		//now := time.Now()
		//token := r.Header.Get("Token")
		//key := fmt.Sprintf("token:%s:%d:%s:%d:%d", token, now.Year(), now.Month(), now.Day(), now.Hour())
		//
		//if n, err := redisClient.GetCount(key); err == nil {
		//    if n > 0 {
		//        n, _ = redisClient.Decrement(key, 1)
		//
		//        SetHeaders(w, n)
		//
		//        log.WithFields(logrus.Fields{
		//            "token": token,
		//            "left":  n,
		//        }).Debug("Tokens left")
		//    } else {
		//        log.WithFields(logrus.Fields{
		//            "token": token,
		//        }).Debug("No tokens left")
		//
		//        w.Header().Add("Content-type", "application/json")
		//        w.WriteHeader(429)
		//        w.Write([]byte(`{"error":"All Tokens Used", "code": 110}`))
		//        return
		//    }
		//} else {
		//    redisClient.SetCount(key, int64(conf.API.RequestLimit), int64(conf.API.RequestLimitKeyExpiry))
		//
		//    SetHeaders(w, int64(conf.API.RequestLimit))
		//
		//    log.WithFields(logrus.Fields{
		//        "token": token,
		//        "left":  n,
		//    }).Debug("Tokens reset")
		//}
		//
		//h(w, r, ps)
	}
}

func SetHeaders(w http.ResponseWriter, remaining int64) {
	w.Header().Set("X-Powered-By", APP_NAME)

	w.Header().Set("X-Rate-Limit-Limit", fmt.Sprintf("%d", conf.API.RequestLimit))
	w.Header().Set("X-Rate-Limit-Remaining", fmt.Sprintf("%d", remaining))
	w.Header().Set("X-Rate-Limit-Reset", helpers.NextFullHour(time.Now()).Format(time.RFC1123Z))
}
