package model

import (
	"github.com/satori/go.uuid"
	"time"
)

type ItemRaw struct {
	ID        uuid.UUID  `gorethink:"id,omitempty" meddler:"id,pk"`
	Hash      []byte     `json:"hash" meddler:"hash"`
	JSON      []byte     `json:"json" meddler:"json"`
	Text      []byte     `json:"text" meddler:"text"`
	CreatedAt *time.Time `json:"-" meddler:"created_at"`
	UpdatedAt *time.Time `json:"-" meddler:"updated_at"`
}
