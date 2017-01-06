package model

import (
	_ "github.com/jinzhu/gorm/dialects/postgres"
	"github.com/satori/go.uuid"
)

type Items []Item

type Media struct {
	Original  *Medium `json:"original,omitempty" meddler:"original"`
	Large     *Medium `json:"large,omitempty" meddler:"large"`
	Medium    *Medium `json:"medium,omitempty" meddler:"medium"`
	Small     *Medium `json:"small,omitempty" meddler:"small"`
	Thumbnail *Medium `json:"thumbnail,omitempty" meddler:"thumbnail"`
}

type Medium struct {
	Url      string  `json:"url" meddler:"url"`
	CacheUrl string  `json:"cache_url,omitempty" meddler:"cache_url"`
	Width    int64   `json:"width,omitempty" meddler:"width"`
	Height   int64   `json:"height,omitempty" meddler:"height"`
	Preview  *Medium `json:"preview,omitempty" meddler:"preview"`
}

type Item struct {
	ID uuid.UUID `json:"id" meddler:"id"`
	//ItemID      uuid.UUID                `json:"item_id" meddler:"item_id"`
	//ItemType    string       `json:"item_type" meddler:"item_type"`
	//MediaType   string     `json:"media_type" meddler:"media_type"`
	//ServiceName string `json:"service" meddler:"service_name"`
	//Title       string                   `json:"title,omitempty" meddler:"title,zeroisnull"`
	//Description string                   `json:"description,omitempty" meddler:"description,zeroisnull"`
	//Author      string                   `json:"author" meddler:"author"`
	//AuthorMedia *Media                   `json:"author_media" meddler:"author_media,json"`
	//Media       []*Media                 `json:"media,omitempty" meddler:"media,json"`
	//Location     string                `json:"location,omitempty" meddler:"location"`
	//LocationName string                `json:"location_name,omitempty" meddler:"location_name"`
	//DefaultLink  string               `json:"default" meddler:"link"`
	//InternalLink string               `json:"internal,default,omitempty" meddler:"link_int"`
	//ExternalLink string               `json:"external,default,omitempty" meddler:"link_ext"`
	//Tags         []string                `json:"tags,omitempty" meddler:"tags,json"`
	//Visibility   string `json:"-" meddler:"visibility"`
	//Points       *int                 `json:"point,omitempty" meddler:"points"`
	//Comments     *int                 `json:"comments,omitempty" meddler:"comments"`
	//Channels     []uuid.UUID          `json:"channels,omitempty" meddler:"channels,json"`
	//CreatedAt    time.Time            `json:"created_at" meddler:"created_at"`
	//UpdatedAt    *time.Time            `json:"updated_at,omitempty" meddler:"updated_at"`
	//DeletedAt    *time.Time            `json:"deleted_at,omitempty" meddler:"deleted_at"`
}

//func (i *Item) buildHash() uuid.UUID {
//	h := sha256.New()
//	h.Write([]byte(i.ServiceName))
//	h.Write(i.ItemID.Bytes())
//
//	id, err := uuid.FromBytes(h.Sum(nil))
//	if err != nil {
//		panic("Failed to create hash")
//	}
//	return id
//}
