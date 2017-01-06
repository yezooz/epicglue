package model

import "github.com/satori/go.uuid"

type ServiceProfile struct {
	ID        uuid.UUID `json:"id" meddler:"id"`
	ServiceID uuid.UUID `json:"service_id" meddler:"service_id"`
}
