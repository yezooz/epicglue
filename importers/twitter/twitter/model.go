package twitter

import (
	"fmt"
	"github.com/ChimeraCoder/anaconda"
	"github.com/epic-glue/common-cli/helpers/enum/item_type"
	"github.com/epic-glue/common-cli/helpers/enum/media_type"
	"github.com/epic-glue/common-cli/helpers/enum/service"
	"github.com/epic-glue/common-cli/model"
	"github.com/yezooz/null"
)

// https://dev.twitter.com/rest/public

const (
	MEDIA_TYPE_PHOTO = "photo"
	MEDIA_TYPE_VIDEO = "video"
)

type Item struct {
	tweet anaconda.Tweet
}

func (item Item) AsModelItem() *model.Post {
	tweet := item.tweet

	post := model.Post{
		Id:      tweet.IdStr,
		Type:    item_type.Tweet,
		Service: service.NewTwitterService(),
		Title:   null.StringFrom(tweet.Text),
		Author: &model.Author{
			Name:     tweet.User.ScreenName,
			FullName: tweet.User.Name,
			Media:    item.buildAuthorMedia(),
		},
		Links: &model.Links{
			Default: fmt.Sprintf("https://twitter.com/%s/status/%d", tweet.User.ScreenName, tweet.Id),
		},
		IsPublic: !tweet.User.Protected,
		Points:   null.IntFrom(int64(tweet.FavoriteCount)),
		Comments: null.IntFrom(int64(tweet.RetweetCount)),
		Extras:   item.buildExtras(),
	}

	createdAt, _ := tweet.CreatedAtTime()
	post.CreatedAt = &createdAt

	if tweet.RetweetedStatus != nil {
		post.Description = null.StringFrom(tweet.RetweetedStatus.Text)
	}

	if tweet.HasCoordinates() {
		post.Location = &model.Location{
			Lon: tweet.Coordinates.Coordinates[0],
			Lat: tweet.Coordinates.Coordinates[1],
		}
	}

	if len(tweet.Entities.Hashtags) > 0 {
		post.Tags = item.buildTags()
	}

	if len(tweet.Entities.Media) > 0 {
		post.Media = item.buildMedia()
	}

	return &post
}

func (item Item) buildExtras() map[string]interface{} {
	return map[string]interface{}{
		"retweeted_status": item.tweet.RetweetedStatus,
		"favorited":        item.tweet.Favorited,
		"retweeted":        item.tweet.Retweeted,
		"place":            item.tweet.Place,
		"lang":             item.tweet.Lang,
	}
}

func (item Item) buildTags() []string {
	tags := []string{}
	for _, el := range item.tweet.Entities.Hashtags {
		tags = append(tags, el.Text)
	}

	return tags
}

func (item Item) buildAuthorMedia() *model.Media {
	return &model.Media{
		Type: MEDIA_TYPE_PHOTO,
		Original: &model.Medium{
			URL: item.tweet.User.ProfileImageUrlHttps,
		},
	}
}

func (item Item) buildMedia() []*model.Media {
	mediaList := []*model.Media{}

	for _, mediaStore := range [][]anaconda.EntityMedia{
		item.tweet.ExtendedEntities.Media,
		item.tweet.Entities.Media,
	} {
		for _, tw := range mediaStore {
			media := model.Media{}

			if tw.Type == MEDIA_TYPE_PHOTO {
				media.Type = media_type.Image
				media.Original = &model.Medium{
					URL: tw.Media_url_https,
				}
			}

			if tw.Type == MEDIA_TYPE_VIDEO {
				media.Type = media_type.Video
				media.Original = &model.Medium{
					URL: item.findVideoWithBestBitrate(tw.VideoInfo.Variants).Url,
				}
			}

			mediaList = append(mediaList, &media)
		}
	}

	return mediaList
}

func (item Item) findVideoWithBestBitrate(variants []anaconda.Variant) anaconda.Variant {
	var bestBitrate anaconda.Variant

	for _, variant := range variants {
		if bestBitrate.Bitrate < variant.Bitrate {
			bestBitrate = variant
		}
	}

	return bestBitrate
}
