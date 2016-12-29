package server

import (
	"fmt"
	"github.com/dgrijalva/jwt-go"
	"net/http"
)

// Auth provides Token-based (JWT) auth
func Auth(w http.ResponseWriter, r *http.Request) {
	token, err := jwt.Parse(r.Header.Get("Token"), func(token *jwt.Token) (interface{}, error) {
		if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, fmt.Errorf("Unexpected signing method: %v", token.Header["alg"])
		}

		lookup := func(kind interface{}) (interface{}, error) {
			return []byte(conf.App.Secret), nil
		}

		return lookup(token.Header["kind"])
	})

	if err != nil {
		w.Header().Add("Content-type", "application/json")
		w.WriteHeader(http.StatusUnauthorized)
		w.Write([]byte(`{"error":"User Unknown", "code": 100}`))
		return
	}

	if claims, ok := token.Claims.(jwt.MapClaims); ok && token.Valid {
		um := user_manager.NewDefaultUserManager(int64(claims["userId"].(float64)))

		if um == nil {
			w.Header().Add("Content-type", "application/json")
			w.WriteHeader(http.StatusUnauthorized)
			w.Write([]byte(`{"error":"User Unknown", "code": 100}`))
			return
		}

		if !um.IsTokenActive(token.Raw) {
			w.Header().Add("Content-type", "application/json")
			w.WriteHeader(http.StatusUnauthorized)
			//w.Write([]byte(`{"error":"Token Invalid", "code": 101}`))
			return
		}

		// TODO: use context instead
		r.Header.Set("User", um.GetUser().Username)
		r.Header.Set("UserId", fmt.Sprintf("%d", um.GetUser().Id))

		h(w, r, ps)
	} else {
		w.Header().Add("Content-type", "application/json")
		w.WriteHeader(http.StatusUnauthorized)
		w.Write([]byte(`{"error":"User Unknown", "code": 100}`))
	}
}
