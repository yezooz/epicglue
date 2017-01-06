package model

import (
	"time"
)

// Pipe is a connection between one or channel.
//
// Once pipe is established, items are starting to flow in
// and are later indexed
type Pipe struct {
	ID        int64       `json:"id" gorethink:"id,omitempty"`
	UserID    User        `json:"-" gorethink:"user_id,reference" gorethink_ref:"id"`
	Channels  []int64     `json:"channels" gorethink:"channels"`
	Query     interface{} `json:"query" gorethink:"query"`
	GroupName string      `json:"group_name" gorethink:"group_name"`
	IsActive  bool        `json:"-" gorethink:"is_active"`
	IsHidden  bool        `json:"-" gorethink:"is_hidden"`
	CreatedAt time.Time   `json:"-" gorethink:"created_at"`
	UpdatedAt *time.Time  `json:"-" gorethink:"updated_at"`
}
