package hacker_news

import (
	"fmt"
	"github.com/uber-go/zap"
	"github.com/yezooz/common-cli/robot"
	"github.com/yezooz/self-control"
	"net/http"
)

const (
	BASE_URL      string = "https://hacker-news.firebaseio.com/v0/"
	DEFAULT_LIMIT int    = 20
)

var log = zap.New(zap.NewJSONEncoder(zap.NoTime()))

type HackerNewsRobot struct {
	robot.CommonRobot

	Limit  int
	Client *http.Client
}

func NewHackerNewsRobot() *HackerNewsRobot {
	r := HackerNewsRobot{
		Client: &http.Client{
			Transport: &self_control.Transport{
				EnableLogging: true,
			},
		},
		Limit: DEFAULT_LIMIT,
	}

	return &r
}

func (hn *HackerNewsRobot) ById(postId int) (*Item, error) {
	return hn.post(fmt.Sprintf("item/%d", postId))
}

func (hn *HackerNewsRobot) Latest() ([]*Item, error) {
	return hn.posts("newstories")
}

func (hn *HackerNewsRobot) Top() ([]*Item, error) {
	return hn.posts("topstories")
}

func (hn *HackerNewsRobot) Best() ([]*Item, error) {
	return hn.posts("beststories")
}

func (hn *HackerNewsRobot) Ask() ([]*Item, error) {
	return hn.posts("askstories")
}

func (hn *HackerNewsRobot) Show() ([]*Item, error) {
	return hn.posts("showstories")
}

func (hn *HackerNewsRobot) Jobs() ([]*Item, error) {
	return hn.posts("jobstories")
}
