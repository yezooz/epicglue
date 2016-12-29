package endpoints

import (
	"net/http"
)

func GetChannels(w http.ResponseWriter, r *http.Request) {
	writeJSON(w, map[string]interface{}{})
}

func AddChannel(w http.ResponseWriter, r *http.Request) {
	writeJSON(w, map[string]interface{}{})
}

func UpdateChannel(w http.ResponseWriter, r *http.Request) {
	writeJSON(w, map[string]interface{}{})
}

func DeleteChannel(w http.ResponseWriter, r *http.Request) {
	writeJSON(w, map[string]interface{}{})
}
