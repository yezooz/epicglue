package twitter

import (
	"github.com/ChimeraCoder/anaconda"
	"github.com/uber-go/zap"
	"net/url"
	"strconv"
)

const (
	DEFAULT_LIMIT int = 200
)

var log = zap.New(zap.NewJSONEncoder(zap.NoTime()))

type TwitterRobot struct {
	twitter *anaconda.TwitterApi
	v       url.Values
}

func NewTwitterRobot(token string, secret string, appKey string, appSecret string) *TwitterRobot {
	anaconda.SetConsumerKey(appKey)
	anaconda.SetConsumerSecret(appSecret)

	t := TwitterRobot{
		twitter: anaconda.NewTwitterApi(token, secret),
		v:       url.Values{},
	}

	// Defaults
	t.SetLimit(DEFAULT_LIMIT)

	return &t
}

func (t *TwitterRobot) SetLimit(limit int) {
	t.v.Set("count", strconv.Itoa(limit))
}

func (t *TwitterRobot) Timeline() ([]*Item, error) {
	tweets, err := t.twitter.GetHomeTimeline(t.v)
	if err != nil {
		log.Error(err.Error())
		return nil, err
	}

	items := make([]*Item, 0)
	for _, tweet := range tweets {
		items = append(items, &Item{
			tweet: tweet,
		})
	}

	return items, nil
}
