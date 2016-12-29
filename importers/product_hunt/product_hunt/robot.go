package product_hunt

import (
	"errors"
	"fmt"
	"github.com/uber-go/zap"
	"github.com/yezooz/common-cli/robot"
	"github.com/yezooz/self-control"
	"net/http"
)

const (
	VERSION      string = "0.1"
	BASE_URL     string = "https://api.producthunt.com/v1/"
	NO_TOKEN_ERR string = "No token provided"
)

var log = zap.New(zap.NewJSONEncoder(zap.NoTime()))

type ProductHuntRobot struct {
	robot.CommonRobot

	Client *http.Client
	Token  string
}

func NewProductHuntRobot(token string) *ProductHuntRobot {
	return &ProductHuntRobot{
		Client: &http.Client{
			Transport: &self_control.Transport{
				EnableLogging: true,
			},
		},
		Token: token,
	}
}

func (ph *ProductHuntRobot) ById(postId int) (*Item, error) {
	return ph.post(fmt.Sprintf("posts/%d", postId))
}

func (ph *ProductHuntRobot) Today() (*Items, error) {
	return ph.posts("posts")
}

func (ph *ProductHuntRobot) DaysAgo(daysAgo int) (*Items, error) {
	return ph.posts(fmt.Sprintf("posts?days_ago=%d", daysAgo))
}

func (ph *ProductHuntRobot) OnDay(day string) (*Items, error) {
	if !validDayFormat.MatchString(day) {
		return nil, errors.New("Invalid date format. YYYY-MM-DD needed.")
	}

	return ph.posts(fmt.Sprintf("posts?day=%s", day))
}

func (ph *ProductHuntRobot) CategoryToday(category CategoryName) (*Items, error) {
	return ph.posts(fmt.Sprintf("categories/%s/posts", category))
}

func (ph *ProductHuntRobot) CategoryDaysAgo(category CategoryName, daysAgo int) (*Items, error) {
	return ph.posts(fmt.Sprintf("categories/%s/posts?days_ago=%d", category, daysAgo))
}

func (ph *ProductHuntRobot) CategoryOnDay(category CategoryName, day string) (*Items, error) {
	if !validDayFormat.MatchString(day) {
		return nil, errors.New("Invalid date format. YYYY-MM-DD needed.")
	}

	return ph.posts(fmt.Sprintf("categories/%s/posts?day=%s", category, day))
}

func (ph *ProductHuntRobot) Latest() (*Items, error) {
	return ph.posts("posts/all")
}

func (ph *ProductHuntRobot) OnPage(page int) (*Items, error) {
	return ph.posts(fmt.Sprintf("posts/all?newer=%d", page))
}

func (ph *ProductHuntRobot) ByUser(userId int) (*Items, error) {
	return ph.posts(fmt.Sprintf("users/%d/posts", userId))
}
