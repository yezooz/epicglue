package server

import (
	"net/http"
)

func Public(w http.ResponseWriter, r *http.Request) {
	// extra logging
}

// Only for internal use
func Private(w http.ResponseWriter, r *http.Request) {
}
