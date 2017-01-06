package model

import "time"

type Feedback struct {
	ID        int64     `json:"id" gorethink:"id,omitempty"`
	UserID    User      `gorethink:"user_id,reference" gorethink_ref:"id"`
	Text      string    `gorethink:"text"`
	CreatedAt time.Time `json:"created_at" gorethink:"created_at"`
}
