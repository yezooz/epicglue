package hacker_news

import (
	"fmt"
	"github.com/spf13/cast"
	"github.com/yezooz/epicglue/common/helpers"
	"github.com/yezooz/epicglue/common/helpers/enum/service"
	"github.com/yezooz/epicglue/importers/common/model"
	"github.com/yezooz/null"
	"strings"
)

type Item struct {
	Id          int64            `json:"id"`
	ParentId    int64            `json:"parent"`
	Type        string           `json:"type"`
	Title       string           `json:"title"`
	Description string           `json:"text,omitempty"`
	Author      string           `json:"by"`
	URL         string           `json:"url"`
	Points      int64            `json:"score"`
	Comments    int64            `json:"descendants"`
	CreatedAt   helpers.UnixTime `json:"time"`
	IsDeleted   bool             `json:"deleted,omitempty"`
	IsDead      bool             `json:"dead,omitempty"`
}

func (item Item) isAskHN() bool {
	return strings.HasPrefix(item.Title, "Ask HN:")
}

func (item Item) isShowHN() bool {
	return strings.HasPrefix(item.Title, "Show HN:")
}

func (item Item) ToModel() *model.Post {
	return &model.Post{
		Id:          cast.ToString(item.Id),
		Type:        item.getItemType(),
		Service:     service.NewHackerNewsService(),
		Title:       null.StringFrom(item.Title),
		Description: null.StringFrom(item.Description),
		Author: &model.Author{
			Name: item.Author,
		},
		Links:     item.buildLinks(),
		Points:    null.IntFrom(item.Points),
		Comments:  null.IntFrom(item.Comments),
		CreatedAt: &item.CreatedAt.Time,
		IsPublic:  true,
		IsActive:  !item.IsDead && !item.IsDeleted,
		Extras:    item.buildExtras(),
	}
}

func (item Item) getItemType() string {
	if item.URL == "" {
		return item_type.Text
	}

	return item_type.Link
}

func (item Item) buildLinks() *model.Links {
	links := model.Links{
		Default:  item.URL,
		Internal: fmt.Sprintf("https://news.ycombinator.com/item?id=%d", item.Id),
	}

	if links.Default == links.Internal {
		links.Internal = ""
	} else {
		links.External = item.URL
	}

	return &links
}

func (item Item) buildExtras() map[string]interface{} {
	extras := map[string]interface{}{}

	if item.isAskHN() {
		extras["ask"] = true
	} else if item.isShowHN() {
		extras["show"] = true
	}

	return extras
}
