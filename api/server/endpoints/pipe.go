package endpoints

import (
	"github.com/julienschmidt/httprouter"
	"net/http"
)

func GetPipe(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	writeJSON(w, map[string]interface{}{})
}

func AddPipe(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	writeJSON(w, map[string]interface{}{})
}

func UpdatePipe(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	writeJSON(w, map[string]interface{}{})
}

func DeletePipe(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	writeJSON(w, map[string]interface{}{})
}
