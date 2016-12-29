package server

import (
	"net/http"
)

// Log sends each request to logger
func Log(w http.ResponseWriter, r *http.Request) {
	//h(w, r, ps)

	//log.WithFields(logrus.Fields{
	//	"method":   r.Method,
	//	"endpoint": r.URL.Path,
	//}).Infof("%s %s", r.Method, r.URL.Path)
}
