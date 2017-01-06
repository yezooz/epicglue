package model

import (
	"github.com/satori/go.uuid"
	"time"
)

type Service struct {
	ID          uuid.UUID `json:"id,omitempty" meddler:"id"`
	ShortName   string    `json:"short_name" meddler:"short_name"`
	Name        string    `json:"name,omitempty" meddler:"name"`
	Description *string   `json:"description,omitempty" meddler:"description"`
	IsVisible   bool      `json:"-" meddler:"is_visible"`
	CreatedAt   time.Time `json:"-" meddler:"created_at,zeroisnull"`
	UpdatedAt   time.Time `json:"-" meddler:"updated_at,zeroisnull"`
}
