package reddit

import (
	"fmt"
	"github.com/uber-go/zap"
	"gitlab.com/epicglue/common-cli/robot"
	"gitlab.com/epicglue/self-control"
	"net/http"
)

const (
	VERSION    string = "0.1"
	BASE_URL   string = "https://www.reddit.com/"
	USER_AGENT string = "Reddit CLI/" + VERSION
)

var log = zap.New(zap.NewJSONEncoder(zap.NoTime()))

type RedditRobot struct {
	robot.CommonRobot

	Client *http.Client
}

func NewRedditRobot() *RedditRobot {
	return &RedditRobot{
		Client: &http.Client{
			Transport: &self_control.Transport{
				EnableLogging: true,
			},
		},
	}
}

func (r *RedditRobot) Subreddit(subreddit string) (*Posts, error) {
	return r.posts(fmt.Sprintf("r/%s", subreddit))
}
