package model

import (
	"time"
)

type ItemContent struct {
	ID          string     `json:"id" gorethink:"id"`
	OrderBy     *time.Time `json:"order_by" gorethink:"order_by"`
	SecondaryID *string    `json:"secondary_id,omitempty" gorethink:"secondary_id"`
	CreatedAt   *time.Time `json:"created_at,omitempty" gorethink:"created_at"`
	UpdatedAt   *time.Time `json:"updated_at,omitempty" gorethink:"updated_at"`
}
