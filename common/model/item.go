package model

import (
	"crypto/sha256"
	"fmt"
	_ "github.com/jinzhu/gorm/dialects/postgres"
	"github.com/yezooz/epicglue/common/helpers"
	"time"
)

var log = helpers.GetLogger("model")

type Item struct {
	ID          string `json:"id" gorethink:"id,omitempty"`
	ItemContent `json:"content" gorethink:"item_content"`
	ItemType    string    `json:"item_type" gorethink:"item_type"`
	MediaType   string    `json:"media_type" gorethink:"media_type"`
	Service     string    `json:"service" gorethink:"service"`
	Title       *string   `json:"title,omitempty" gorethink:"title"`
	Description *string   `json:"description,omitempty" gorethink:"description"`
	Author      string    `json:"author" gorethink:"author"`
	AuthorMedia *Media    `json:"author_media" gorethink:"author_media"`
	Media       []*Media  `json:"media,omitempty" gorethink:"media"`
	Location    *Location `json:"location,omitempty" gorethink:"location"`
	Links       `json:"links" gorethink:"links"`
	Tags        []string   `json:"tags,omitempty" gorethink:"tags"`
	Visibility  string     `json:"-" gorethink:"visibility"`
	Points      *int64     `json:"point,omitempty" gorethink:"points"`
	Comments    *int64     `json:"comments,omitempty" gorethink:"comments"`
	IsRead      bool       `json:"is_read" gorethink:"-"`
	IsGlued     bool       `json:"is_glued" gorethink:"-"`
	Channels    []int64    `json:"channels,omitempty" gorethink:"-"`
	CreatedAt   time.Time  `json:"created_at" gorethink:"created_at"`
	UpdatedAt   *time.Time `json:"updated_at,omitempty" gorethink:"updated_at"`
	DeletedAt   *time.Time `json:"deleted_at,omitempty" gorethink:"deleted_at"`
	IndexedAt   time.Time  `json:"indexed_at" gorethink:"-"`
}

func (i *Item) buildHash() string {
	content_id := i.ItemContent.ID
	if i.ItemContent.SecondaryID != nil {
		content_id = *i.ItemContent.SecondaryID
	}

	hasher := sha256.New()
	hasher.Write([]byte(i.Service))
	hasher.Write([]byte(content_id))

	return fmt.Sprintf("%x", hasher.Sum(nil))
}
