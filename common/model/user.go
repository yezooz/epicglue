package model

import (
	"time"
)

type User struct {
	ID        int64      `json:"id" gorethink:"id,omitempty"`
	Devices   []*Device  `json:"-" gorethink:"devices"`
	CreatedAt time.Time  `json:"-" gorethink:"created_at"`
	UpdatedAt *time.Time `json:"-" gorethink:"updated_at"`
}
