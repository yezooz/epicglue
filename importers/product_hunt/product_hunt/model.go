package product_hunt

import (
	"github.com/yezooz/null"
	"gitlab.com/epicglue/common-cli/helpers/enum/item_type"
	"gitlab.com/epicglue/common-cli/helpers/enum/service"
	"gitlab.com/epicglue/common-cli/model"
	"strconv"
	"time"
)

// https://api.producthunt.com/v1/docs

type Items struct {
	Items []Item `json:"posts"`
}

type Item struct {
	Id             int64     `json:"id"`
	CategoryId     int64     `json:"category_id"`
	Day            string    `json:"day"`
	Name           string    `json:"name"`
	Tagline        string    `json:"tagline"`
	Points         int64     `json:"votes_count"`
	Comments       int64     `json:"comments_count"`
	CreatedAt      time.Time `json:"created_at"`
	Url            string    `json:"discussion_url"`
	RedirectUrl    string    `json:"redirect_url"`
	IsExclusive    bool      `json:"exclusive"`
	IsFeatured     bool      `json:"featured"`
	IsMarkerInside bool      `json:"marker_inside"`
	Markers        []*Marker `json:"markers"`
	Topics         []*Topic  `json:"topics"`
	Screenshots    struct {
		Size300px string `json:"300px"`
		Size850px string `json:"850px"`
	} `json:"screenshot_url"`
	Thumbnail *Thumbnail `json:"thumbnail"`
	User      *User      `json:"user"`
}

func (item Item) AsModelItem() *model.Post {
	return &model.Post{
		Id:          strconv.Itoa(int(item.Id)),
		CreatedAt:   &item.CreatedAt,
		Type:        item_type.Link,
		Service:     service.NewProductHuntService(),
		Title:       null.StringFrom(item.Name),
		Description: null.StringFrom(item.Tagline),
		Author: &model.Author{
			Name: item.User.Username,
			Media: &model.Media{
				Original: &model.Medium{
					URL: item.User.Images.Original,
				},
				Large: &model.Medium{
					URL:    item.User.Images.Size88px,
					Width:  264,
					Height: 264,
				},
				Medium: &model.Medium{
					URL:    item.User.Images.Size44px,
					Width:  132,
					Height: 132,
				},
				Small: &model.Medium{
					URL:    item.User.Images.Size40px,
					Width:  120,
					Height: 120,
				},
				Thumbnail: &model.Medium{
					URL:    item.User.Images.Size32px,
					Width:  96,
					Height: 96,
				},
			},
		},
		Links: &model.Links{
			Default:  item.Url,
			Internal: item.Url,
			External: item.RedirectUrl,
		},
		Media:    item.buildMedia(),
		IsPublic: true,
		Points:   null.IntFrom(item.Points),
		Comments: null.IntFrom(item.Comments),
		Extras:   item.buildExtras(),
	}
}

func (item Item) buildMedia() []*model.Media {
	return []*model.Media{
		{
			Original: &model.Medium{
				URL:    item.Screenshots.Size850px,
				Width:  850,
				Height: 850,
			},
			Medium: &model.Medium{
				URL:    item.Screenshots.Size300px,
				Width:  300,
				Height: 300,
			},
		},
	}
}

func (item Item) buildExtras() map[string]interface{} {
	return map[string]interface{}{
		"topics": item.Topics,
	}
}

type User struct {
	Id              int         `json:"id"`
	Name            string      `json:"name"`
	Username        string      `json:"username"`
	Headline        string      `json:"headline"`
	TwitterUsername string      `json:"twitter_username"`
	WebsiteUrl      string      `json:"website_url"`
	ProfileUrl      string      `json:"profile_url"`
	Images          *MakerImage `json:"image_url"`
	CreatedAt       time.Time   `json:"created_at"`
}

type Thumbnail struct {
	Id        int    `json:"id"`
	MediaType string `json:"media_type"`
	ImageUrl  string `json:"image_url"`
}

type Topic struct {
	Id   int    `json:"id"`
	Name string `json:"name"`
	Slug string `json:"slug"`
}

type Marker struct {
	Id              int         `json:"id"`
	CreatedAt       time.Time   `json:"created_at"`
	Name            string      `json:"name"`
	Headline        string      `json:"headline"`
	Username        string      `json:"username"`
	TwitterUsername string      `json:"twitter_username"`
	WebsiteUrl      string      `json:"website_url"`
	ProfileUrl      string      `json:"profile_url"`
	Images          *MakerImage `json:"image_url"`
}

type MakerImage struct {
	Original string `json:"original"`
	Size32px string `json:"32px@3X"`
	Size40px string `json:"40px@3X"`
	Size44px string `json:"44px@3x"`
	Size88px string `json:"88px@3X"`
}
