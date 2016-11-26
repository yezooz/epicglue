package model

import (
	"time"
)

type UserItem struct {
	ID        int64      `json:"id" gorethink:"id,omitempty"`
	Item      Item       `json:"item" gorethink:"item_id,reference" gorethink_ref:"id"`
	User      User       `json:"user" gorethink:"user_id,reference" gorethink_ref:"id"`
	Channels  []int64    `json:"channels" gorethink:"channels"`
	IsRead    bool       `json:"read" gorethink:"is_read"`
	IsGlued   bool       `json:"glued" gorethink:"is_glued"`
	IsDeleted bool       `json:"glued" gorethink:"is_deleted"`
	CreatedAt time.Time  `json:"-" gorethink:"created_at"`
	UpdatedAt *time.Time `json:"-" gorethink:"updated_at"`
}
