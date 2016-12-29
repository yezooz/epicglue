package endpoints

import (
	"net/http"
)

func GetPipes(w http.ResponseWriter, r *http.Request) {
	writeJSON(w, map[string]interface{}{})
}

func AddPipe(w http.ResponseWriter, r *http.Request) {
	writeJSON(w, map[string]interface{}{})
}

func UpdatePipe(w http.ResponseWriter, r *http.Request) {
	writeJSON(w, map[string]interface{}{})
}

func DeletePipe(w http.ResponseWriter, r *http.Request) {
	writeJSON(w, map[string]interface{}{})
}
