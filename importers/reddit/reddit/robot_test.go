package reddit_test

import (
	"github.com/stretchr/testify/assert"
	"gitlab.com/epicglue/reddit-cli/reddit"
	"gitlab.com/epicglue/self-control"
	"io/ioutil"
	"net/http"
	"testing"
)

func TestRedditRobot_Subreddit(t *testing.T) {
	responseJSON, err := ioutil.ReadFile("../test/images.json")
	if err != nil {
		t.Fatal(err)
	}

	robot := &reddit.RedditRobot{
		Client: self_control.FakeHttpClient(
			http.StatusOK,
			map[string]string{},
			string(responseJSON),
		),
	}

	posts, err := robot.Subreddit("images")

	assert.Nil(t, err)
	assert.NotNil(t, posts)
	assert.Len(t, posts.Data.Children, 25)
}
