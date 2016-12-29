package kickstarter

import (
	"github.com/uber-go/zap"
	"github.com/yezooz/common-cli/robot"
	"github.com/yezooz/self-control"
	"net/http"
)

const (
	BASE_URL string = "https://www.kickstarter.com/discover/advanced?format=json"
)

var log = zap.New(zap.NewJSONEncoder(zap.NoTime()))

type KickstarterRobot struct {
	robot.CommonRobot

	Client *http.Client
}

func NewKickstarterRobot() *KickstarterRobot {
	k := KickstarterRobot{
		Client: &http.Client{
			Transport: &self_control.Transport{
				EnableLogging: true,
			},
		},
	}

	return &k
}

func (k *KickstarterRobot) Category(category string, sort string) (*Items, error) {
	return k.itemsByCategory(category, sort)
}

func (k *KickstarterRobot) Project(url string) (*Item, error) {
	return k.itemByUrl(url)
}
