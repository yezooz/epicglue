package reddit

import (
	"fmt"
	"github.com/yezooz/common-cli/helpers"
	"github.com/yezooz/common-cli/helpers/enum/item_type"
	"github.com/yezooz/common-cli/helpers/enum/media_type"
	"github.com/yezooz/common-cli/helpers/enum/service"
	"github.com/yezooz/common-cli/model"
	"github.com/yezooz/null"
	"github.com/yezooz/sanitize"
	"html"
)

// https://github.com/reddit/reddit/wiki/JSON

type Posts struct {
	Kind string `json:"kind"`
	Data struct {
		ModHash  string   `json:"modhash"`
		Before   string   `json:"before,omitempty"`
		After    string   `json:"after,omitempty"`
		Children []*Thing `json:"children"`
	} `json:"data"`
}

type Thing struct {
	Kind string `json:"kind"`
	Data *Post  `json:"data"`
	Id   string `json:"id,omitempty"`
	Name string `json:"name,omitempty"`
}

type Post struct {
	Id                  string      `json:"id"`
	Name                string      `json:"name"`
	Author              string      `json:"author,omitempty"`
	AuthorFlairCSSClass string      `json:"author_flair_css_class,omityempty"`
	AuthorFlairText     string      `json:"author_flair_text,omitempty"`
	IsClicked           bool        `json:"clicked"`
	Domain              string      `json:"domain"`
	IsHidden            bool        `json:"hidden"`
	IsSelf              bool        `json:"is_self"`
	UserLikes           bool        `json:"likes,omitempty"`
	LinkFlairCSSClass   string      `json:"link_flair_css_class,omitempty"`
	LinkFlairText       string      `json:"link_flair_text,omitempty"`
	IsLocked            bool        `json:"locked"`
	Media               *Media      `json:"media,omitempty"`
	SecureMedia         *Media      `json:"secure_media,omitempty"`
	MediaEmbed          *MediaEmbed `json:"media_embed,omitempty"`
	SecureMediaEmbed    *MediaEmbed `json:"secure_media_embed,omitempty"`
	Preview             struct {
		Images []*Preview `json:"images"`
	} `json:"preview"`
	Subreddit       string           `json:"subreddit"`
	SubredditId     string           `json:"subreddit_id"`
	SelfText        string           `json:"selftext"`
	SelfTextHTML    string           `json:"selftext_html"`
	UserReports     []*UserReport    `json:"user_reports"`
	Ups             int64            `json:"ups"`
	Downs           int64            `json:"downs"`
	Points          int64            `json:"score"`
	Comments        int64            `json:"num_comments"`
	NumberOfReports int64            `json:"num_reports"`
	IsNSFW          bool             `json:"over_18"`
	Permalink       string           `json:"permalink"`
	IsSaved         bool             `json:"is_saved"`
	Thumbnail       string           `json:"thumbnail"`
	Title           string           `json:"title"`
	Url             string           `json:"url"`
	EditedAt        helpers.UnixTime `json:"edited,omitempty"`
	Distinguished   string           `json:"distinguished,omitempty"`
	IsStickied      bool             `json:"stickied"`
	HasVisited      bool             `json:"visited"`
	IsArchived      bool             `json:"archived"`
	ApprovedBy      string           `json:"approved_by,omitempty"`
	BannedBy        string           `json:"banned_by,omitempty"`
	CreatedAt       helpers.UnixTime `json:"created_utc"`
}

func (post Post) ToModel() *model.Post {
	return &model.Post{
		Id:          post.Id,
		Type:        item_type.Link,
		Service:     service.NewRedditService(),
		Title:       null.StringFrom(post.cleanString(post.Title)),
		Description: null.StringFrom(post.cleanString(post.SelfText)),
		Author: &model.Author{
			Name: post.Author,
		},
		Links: &model.Links{
			Default:  fmt.Sprintf("https://www.reddit.com%s", post.Permalink),
			Internal: fmt.Sprintf("https://www.reddit.com%s", post.Permalink),
			External: post.Url,
		},
		Media:     post.buildMedia(),
		IsPublic:  true,
		IsActive:  true,
		CreatedAt: &post.CreatedAt.Time,
		Points:    null.IntFrom(post.Points),
		Comments:  null.IntFrom(post.Comments),
		Extras:    post.buildExtras(),
	}
}

func (post Post) buildExtras() map[string]interface{} {
	return map[string]interface{}{
		"up":   post.Ups,
		"down": post.Downs,
		"nsfw": post.IsNSFW,
	}
}

func (post Post) buildMedia() []*model.Media {
	if post.Media == nil {
		return nil
	}

	media := model.Media{}

	switch post.Media.Type {
	case "streamable.com":
	case "youtube.com":
		media.Type = media_type.Video
		media.Original = &model.Medium{
			URL:    post.Media.Embed.ThumbnailUrl,
			Width:  post.Media.Embed.Width,
			Height: post.Media.Embed.Height,
			Preview: &model.Media{
				Thumbnail: &model.Medium{
					URL:    post.Media.Embed.ThumbnailUrl,
					Width:  post.Media.Embed.ThumbnailWidth,
					Height: post.Media.Embed.ThumbnailHeight,
				},
			},
		}
		break
	case "imgur.com":
		media.Type = media_type.Image
		media.Original = &model.Medium{
			URL:    post.Media.Embed.ThumbnailUrl,
			Width:  post.Media.Embed.Width,
			Height: post.Media.Embed.Height,
		}
		media.Thumbnail = &model.Medium{
			URL:    post.Media.Embed.ThumbnailUrl,
			Width:  post.Media.Embed.ThumbnailWidth,
			Height: post.Media.Embed.ThumbnailHeight,
		}
		break
	default:
		return nil
	}

	return []*model.Media{
		&media,
	}
}

func (post Post) cleanString(str string) string {
	return sanitize.HTML(html.UnescapeString(str))
}

type Media struct {
	Type  string `json:"type"`
	Embed struct {
		ProviderUrl     string `json:"provider_url"`
		ProviderName    string `json:"provider_name"`
		Type            string `json:"type"`
		Title           string `json:"title"`
		Description     string `json:"description"`
		Version         string `json:"version"`
		URL             string `json:"url"`
		HTML            string `json:"html"`
		Width           int    `json:"width"`
		Height          int    `json:"height"`
		ThumbnailWidth  int    `json:"thumbnail_width"`
		ThumbnailHeight int    `json:"thumbnail_height"`
		ThumbnailUrl    string `json:"thumbnail_url"`
	} `json:"oembed"`
}

type MediaEmbed struct {
	Content   string `json:"content"`
	Width     int    `json:"width"`
	Height    int    `json:"height"`
	Scrolling bool   `json:"scrolling"`
}

type Preview struct {
	Id          string        `json:"id"`
	Resolutions []*Resolution `json:"resolutions"`
	Source      *Resolution   `json:"source"`
	Variants    *Variant      `json:"variants"`
}

func (prev Preview) resolutionAtI(i int) *model.Medium {
	return &model.Medium{
		URL:    prev.Resolutions[i].URL,
		Height: prev.Resolutions[i].Height,
		Width:  prev.Resolutions[i].Width,
	}
}

type Resolution struct {
	URL    string `json:"url"`
	Width  int    `json:"width"`
	Height int    `json:"height"`
}

type Variant struct {
	Gif *Preview `json:"gif"`
	MP4 *Preview `json:"mp4"`
}

// TODO
type UserReport struct {
}

type Comment struct {
	Id                  string           `json:"id"`
	ParentId            string           `json:"parent_id,omitempty"`
	Title               string           `json:"link_title"`
	ApprovedBy          string           `json:"approved_by"`
	Author              string           `json:"author,omitempty"`
	AuthorFlairCSSClass string           `json:"author_flair_css_class,omityempty"`
	AuthorFlairText     string           `json:"author_flair_text,omitempty"`
	BannedBy            string           `json:"banned_by,omitempty"`
	Body                string           `json:"body"`
	BodyHTML            string           `json:"body_html"`
	Edited              helpers.UnixTime `json:"edited,omitempty"`
	Gold                int              `json:"gilded"`
	UserLikes           bool             `json:"likes"`
	LinkAuthor          string           `json:"link_author,omitempty"`
	LinkId              string           `json:"link_id"`
	LinkTitle           string           `json:"link_title"`
	LinkUrl             string           `json:"link_url"`
	NumberOfReports     int              `json:"num_reports"`
	Subreddit           string           `json:"subreddit"`
	SubredditId         string           `json:"subreddit_id"`
	Score               int              `json:"score"`
	IsScoreHidden       bool             `json:"score_hidden"`
	Distinguished       string           `json:"distinguished,omitempty"`
	Replies             []Thing          `json:"replies"`
}

// TODO
type Subreddit struct {
}

// TODO
type Message struct {
}

// TODO
type Account struct {
}
