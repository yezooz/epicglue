package kickstarter_test

import (
	"github.com/stretchr/testify/assert"
	"github.com/yezooz/kickstarter-cli/kickstarter"
	"github.com/yezooz/self-control"
	"io/ioutil"
	"net/http"
	"testing"
)

func testProjectPage(t *testing.T, filename string) *kickstarter.Item {
	responseJSON, err := ioutil.ReadFile("../test/" + filename)
	if err != nil {
		t.Fatal(err)
	}

	robot := &kickstarter.KickstarterRobot{
		Client: self_control.FakeHttpClient(
			http.StatusOK,
			map[string]string{},
			string(responseJSON),
		),
	}

	post, err := robot.Project("http://www.kickstarter.com/projects/1960349413/unfair?ref=category_popular")

	if err != nil {
		t.Fatal(err)
	}

	return post
}

func TestProjectPageActiveRaising(t *testing.T) {
	item := testProjectPage(t, "project_active_raising.html")

	assert.Equal(t, 2790.0, item.Pledged)
	assert.Equal(t, 10000.0, item.Goal)
	assert.Equal(t, kickstarter.StateLive, item.State)
}

func TestProjectPageActiveNotRaisedYet(t *testing.T) {
	item := testProjectPage(t, "project_active_not_raised.html")

	assert.Equal(t, 0.0, item.Pledged)
	assert.Equal(t, 180000.0, item.Goal)
	assert.Equal(t, kickstarter.StateLive, item.State)
}

func TestProjectPageActiveRaised(t *testing.T) {
	item := testProjectPage(t, "project_active_raised.html")

	assert.Equal(t, 142379.21, item.Pledged)
	assert.Equal(t, 30000.0, item.Goal)
	assert.Equal(t, kickstarter.StateLive, item.State)
}

func TestProjectPageSuccessful(t *testing.T) {
	item := testProjectPage(t, "project_successful.html")

	assert.Equal(t, 0.0, item.Pledged)
	assert.Equal(t, 0.0, item.Goal)
	assert.Equal(t, kickstarter.StateSuccessful, item.State)
}

func TestProjectPageFailed(t *testing.T) {
	item := testProjectPage(t, "project_failed.html")

	assert.Equal(t, 0.0, item.Pledged)
	assert.Equal(t, 2000.0, item.Goal)
	assert.Equal(t, kickstarter.StateFailed, item.State)
}
