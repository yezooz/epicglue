package model

import (
	"time"
)

type ItemRaw struct {
	ID        string     `gorethink:"id,omitempty" gorethink:"id,omitempty"`
	Hash      string     `json:"hash" gorethink:"hash"`
	JSON      []byte     `json:"json" gorethink:"json"`
	Text      []byte     `json:"text" gorethink:"text"`
	CreatedAt *time.Time `json:"-" gorethink:"created_at"`
	UpdatedAt *time.Time `json:"-" gorethink:"updated_at"`
}
