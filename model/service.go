package model

import (
	"time"
)

type Service struct {
	ID          int64      `json:"id,omitempty" gorethink:"id,omitempty"`
	ShortName   string     `json:"short_name" gorethink:"short_name"`
	Name        string     `json:"name,omitempty" gorethink:"name"`
	Description *string    `json:"description,omitempty" gorethink:"description"`
	IsVisible   bool       `json:"-" gorethink:"is_visible"`
	CreatedAt   time.Time  `json:"-" gorethink:"created_at"`
	UpdatedAt   *time.Time `json:"-" gorethink:"updated_at"`
}
