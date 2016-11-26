package endpoints

import (
	"encoding/json"
	"github.com/Sirupsen/logrus"
	"github.com/yezooz/epicglue/common/helpers"
	"net/http"
	"runtime/debug"
	"time"
)

var log = helpers.GetLogger("webserver")

func writeJSON(w http.ResponseWriter, jsonableObject interface{}) {
	startTime := time.Now()

	w.Header().Add("Content-type", "application/json")

	if j, err := json.Marshal(jsonableObject); err == nil {
		w.Write(j)

		log.WithFields(logrus.Fields{
			"took":     time.Since(startTime),
			"took_str": time.Since(startTime).String(),
			"action":   "writeJSON",
		}).Debug("writeJSON")
	} else {
		log.WithFields(logrus.Fields{
			"took":     time.Since(startTime),
			"took_str": time.Since(startTime).String(),
			"action":   "writeJSON",
			"stack":    string(debug.Stack()),
		}).Error(err)
	}
}
