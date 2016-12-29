package kickstarter

import (
	"fmt"
	"github.com/spf13/cast"
	"github.com/yezooz/common-cli/helpers"
	"github.com/yezooz/common-cli/helpers/enum/item_type"
	"github.com/yezooz/common-cli/helpers/enum/service"
	"github.com/yezooz/common-cli/model"
	"github.com/yezooz/null"
	"time"
)

// https://github.com/markolson/kickscraper/issues/16#issuecomment-31409151

type Items struct {
	Items []Item `json:"projects"`
}

type Item struct {
	Id                   int              `json:"id"`
	Name                 string           `json:"name"`
	Description          string           `json:"blurb"`
	Goal                 float64          `json:"goal"`
	Pledged              float64          `json:"pledged"`
	State                string           `json:"state"`
	Slug                 string           `json:"slug"`
	DisableCommunication bool             `json:"disable_communication"`
	Country              string           `json:"country"`
	Currency             string           `json:"currency"`
	CurrencySymbol       string           `json:"currency_symbol"`
	CurrencyTrailingCode bool             `json:"currency_trailing_code"`
	EndDate              helpers.UnixTime `json:"deadline"`
	StateChangeDate      helpers.UnixTime `json:"state_changed_at"`
	LaunchDate           helpers.UnixTime `json:"launched_at"`
	CreateDate           helpers.UnixTime `json:"created-at"`
	BackersCount         int              `json:"backers_count"`
	Photo                *Photo           `json:"photo"`
	Creator              *Creator         `json:"creator"`
	Location             *Location        `json:"location"`
	Category             *Category        `json:"category"`
	Profile              *Profile         `json:"profile"`
	Spotlight            bool             `json:"spotlight"`
	URLs                 struct {
		Web struct {
			Project string `json:"project"`
			Rewards string `json:"rewards"`
		} `json:"web"`
	} `json:"urls"`
}

func (item Item) ToModel() *model.Post {
	return &model.Post{
		Id:          cast.ToString(item.Id),
		Type:        item_type.Auction,
		Service:     service.NewKickstarterService(),
		Title:       null.StringFrom(item.Name),
		Description: null.StringFrom(item.Description),
		Author: &model.Author{
			Name: item.Creator.Name,
		},
		Links: &model.Links{
			Default: item.URLs.Web.Project,
		},
		Media:     item.buildMedia(),
		IsPublic:  true,
		IsActive:  true,
		CreatedAt: &item.LaunchDate.Time,
		Extras:    item.buildExtras(),
	}
}

func (item Item) buildExtras() map[string]interface{} {
	var (
		goal     string
		pledged  string
		daysLeft int
	)

	if item.CurrencyTrailingCode {
		goal = fmt.Sprintf("%s%.2f", item.CurrencySymbol, item.Goal)
		pledged = fmt.Sprintf("%s%.2f", item.CurrencySymbol, item.Pledged)
	} else {
		goal = fmt.Sprintf("%.2f %s", item.Goal, item.Currency)
		pledged = fmt.Sprintf("%.2f %s", item.Pledged, item.Currency)
	}

	daysLeft = int(item.EndDate.Time.Sub(time.Now()).Hours() / 24)

	return map[string]interface{}{
		"state":       item.State,
		"goal":        goal,
		"pledged":     pledged,
		"days_left":   daysLeft,
		"launch_date": item.LaunchDate,
		"end_date":    item.EndDate,
	}
}

func (i Item) buildMedia() []*model.Media {
	media := &model.Media{
		Original: &model.Medium{
			URL:    i.Photo.Full,
			Width:  560,
			Height: 315,
		},
		Large: &model.Medium{
			URL:    i.Photo.Size1536x864,
			Width:  1536,
			Height: 864,
		},
		Medium: &model.Medium{
			URL:    i.Photo.Size1024x576,
			Width:  1024,
			Height: 576,
		},
		Small: &model.Medium{
			URL:    i.Photo.Medium,
			Width:  266,
			Height: 150,
		},
		Thumbnail: &model.Medium{
			URL:    i.Photo.Thumbnail,
			Width:  40,
			Height: 22,
		},
	}

	return []*model.Media{
		media,
	}
}

type Photo struct {
	Full         string `json:"full,omitempty"`
	Ed           string `json:"ed,omitempty"`
	Medium       string `json:"med"`
	Little       string `json:"little,omitempty"`
	Small        string `json:"small"`
	Thumbnail    string `json:"thumb"`
	Size1024x576 string `json:"1024x576,omitempty"`
	Size1536x864 string `json:"1536x864,omitempty"`
}

type Creator struct {
	ID     int    `json:"id"`
	Name   string `json:"name"`
	Avatar *Photo `json:"avatar"`
	URLS   struct {
		Web struct {
			User string `json:"user"`
		} `json:"web"`
		API struct {
			User string `json:"user"`
		} `json:"api"`
	} `json:"urls"`
}

type Location struct {
	ID              int    `json:"id"`
	Name            string `json:"name"`
	Slug            string `json:"slug"`
	ShortName       string `json:"short_name"`
	DisplayableName string `json:"displayable_name"`
	Country         string `json:"country"`
	State           string `json:"state"`
	Type            string `json:"type"`
	IsRoot          bool   `json:"is_root"`
	URL             struct {
		Web struct {
			Discover string `json:"discover"`
			Location string `json:"location"`
		} `json:"web"`
	} `json:"urls"`
	API struct {
		NearbyProjects string `json:"nearby_projects"`
	} `json:"api"`
}

type Category struct {
	ID       int    `json:"id"`
	Name     string `json:"name"`
	Slug     string `json:"slug"`
	Position int    `json:"position"`
	ParentId int    `json:"parent_id"`
	URLs     struct {
		Web struct {
			Discover string `json:"discover"`
		} `json:"web"`
	} `json:"urls"`
}

type Profile struct {
	ID                     int              `json:"id"`
	ProjectId              int              `json:"project_id"`
	State                  string           `json:"state"`
	StateChangedDate       helpers.UnixTime `json:"state_changed_at"`
	Name                   string           `json:"name"`
	Description            string           `json:"blurb"`
	BackgroundColor        string           `json:"background_color"`
	TextColor              string           `json:"text_color"`
	LinkBackgroundColor    string           `json:"link_background_color"`
	LinkTextColor          string           `json:"link_text_color"`
	LinkText               string           `json:"link_text"`
	LinkUrl                string           `json:"link_url"`
	ShowFeatureImage       bool             `json:"show_feature_image"`
	BackgroundImageOpacity float64          `json:"background_image_opacity"`
	ShouldShowFeatureImage bool             `json:"should_show_feature_image"`
	FeatureImageAttributes struct {
		Images struct {
			Default      string `json:"default"`
			BaseballCard string `json:"baseball_card"`
		} `json:"image_urls"`
	} `json:"feature_image_attributes"`
}
