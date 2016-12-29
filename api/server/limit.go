package server

import (
	"net/http"
)

// Limit does Rate-Limiting for endpoints
func Limit(w http.ResponseWriter, r *http.Request) {
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
