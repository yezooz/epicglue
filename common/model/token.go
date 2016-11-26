package model

import (
	"time"
)

type Token struct {
	Service      Service    `json:"service" gorethink:"service_id,reference" gorethink_ref:"id"`
	Identifier   string     `json:"identifier" gorethink:"identifier"`
	FriendlyName *string    `json:"friendly_name" gorethink:"friendly_name"`
	Token        string     `json:"token" gorethink:"token"`
	TokenSecret  *string    `json:"token_secret" gorethink:"token_secret"`
	RefreshToken *string    `json:"refresh_token" gorethink:"refresh_token"`
	Expiry       *time.Time `json:"expiry" gorethink:"expiry"`
	Scope        *string    `json:"scope" gorethink:"scope"`
}
