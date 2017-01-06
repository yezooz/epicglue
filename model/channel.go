package model

import (
	"time"
)

// Channel is a item storage. Items can be added automatically but running defined CLIs
// but could also be populated by customer or 3rd party via the API
//
// If Cmd is null, channel is not populated automatically
// If User is null, channel is public
//
// ServiceProfile is optional for auto-populated channels, where client's token is needed

type Channel struct {
	ID               int64           `json:"id" gorethink:"id,omitempty"`
	User             *User           `json:"-" gorethink:"user_id,reference" gorethink_ref:"id"`
	ServiceProfileID *ServiceProfile `json:"-" gorethink:"service_profile_id,reference" gorethink_ref:"id"`
	Cmd              string          `json:"-" gorethink:"cmd"`
	GroupName        string          `json:"group_name" gorethink:"group_name"`
	Name             string          `json:"name" gorethink:"name"`
	Description      *string         `json:"description,omitempty"  gorethink:"description"`
	IsActive         bool            `json:"-" gorethink:"is_active"`
	IsHidden         bool            `json:"-" gorethink:"is_hidden"`
	MinRefresh       int             `json:"-" gorethink:"min_refresh"`
	CreatedAt        time.Time       `json:"-" gorethink:"created_at"`
	UpdatedAt        *time.Time      `json:"-" gorethink:"updated_at"`
}
