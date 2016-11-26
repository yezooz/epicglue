package model

import (
	"github.com/yezooz/null"
	"time"
)

type Post struct {
	Id          string                 `json:"id"`
	Service     *Service               `json:"service"`
	Type        string                 `json:"type"`
	Title       null.String            `json:"title"`
	Description null.String            `json:"description"`
	Author      *Author                `json:"author"`
	Media       []*Media               `json:"media,omitempty"`
	Tags        []string               `json:"tags,omitmempty"`
	Location    *Location              `json:"location,omitempty"`
	Links       *Links                 `json:"links"`
	ItemHash    null.String            `json:"-"`
	Extras      map[string]interface{} `json:"extras"`
	Points      null.Int               `json:"points,omitempty"`
	Comments    null.Int               `json:"comments,omitempty"`
	IsPublic    bool                   `json:"is_public"`
	IsActive    bool                   `json:"is_active"`
	CreatedAt   *time.Time             `json:"created_at"`
	UpdatedAt   *null.Time             `json:"updated_at,omitempty"`
	DeletedAt   *null.Time             `json:"deleted_at,omitempty"`
}
