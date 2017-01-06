package model

import (
	"github.com/satori/go.uuid"
	"time"
)

type Token struct {
	ID           uuid.UUID `json:"id" meddler:"id"`
	Service      Service   `json:"service" meddler:"service_id"`
	Handle       string    `json:"handle" meddler:"handle"`
	FriendlyName string    `json:"friendly_name" meddler:"friendly_name"`
	Token        string    `json:"token" meddler:"token"`
	TokenSecret  string    `json:"token_secret" meddler:"token_secret"`
	RefreshToken string    `json:"refresh_token" meddler:"refresh_token"`
	Expiry       time.Time `json:"expiry" meddler:"expiry,zeroisnull"`
	Scope        string    `json:"scope" meddler:"scope"`
}
