package endpoints

import (
	"github.com/julienschmidt/httprouter"
	"net/http"
)

func GetChannels(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	writeJSON(w, map[string]interface{}{})
}

func AddChannel(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	writeJSON(w, map[string]interface{}{})
}

func UpdateChannel(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	writeJSON(w, map[string]interface{}{})
}

func DeleteChannel(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	writeJSON(w, map[string]interface{}{})
}
