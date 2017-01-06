package model

import (
	"github.com/satori/go.uuid"
	"time"
)

type ItemRaw struct {
	ID        uuid.UUID `meddler:"id"`
	Hash      []byte    `json:"hash" meddler:"hash"`
	JSON      []byte    `json:"json" meddler:"json"`
	Text      []byte    `json:"text" meddler:"text"`
	CreatedAt time.Time `json:"-" meddler:"created_at,zeroisnull"`
	UpdatedAt time.Time `json:"-" meddler:"updated_at,zeroisnull"`
}
