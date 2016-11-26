package product_hunt_test

import (
	"github.com/stretchr/testify/assert"
	"gitlab.com/epicglue/product-hunt-cli/product_hunt"
	"gitlab.com/epicglue/self-control"
	"io/ioutil"
	"net/http"
	"testing"
)

func TestProductHuntRobot(t *testing.T) {
	responseJSON, err := ioutil.ReadFile("../test/today.json")
	if err != nil {
		t.Fatal(err)
	}

	robot := &product_hunt.ProductHuntRobot{
		Client: self_control.FakeHttpClient(
			http.StatusOK,
			map[string]string{},
			string(responseJSON),
		),
	}

	posts, err := robot.Today()

	assert.NotNil(t, err)
	assert.Nil(t, posts)
	assert.Equal(t, err.Error(), product_hunt.NO_TOKEN_ERR)
}

func TestProductHuntRobot_Today(t *testing.T) {
	responseJSON, err := ioutil.ReadFile("../test/today.json")
	if err != nil {
		t.Fatal(err)
	}

	robot := &product_hunt.ProductHuntRobot{
		Client: self_control.FakeHttpClient(
			http.StatusOK,
			map[string]string{},
			string(responseJSON),
		),
		Token: "abcd",
	}

	posts, err := robot.Today()

	assert.Nil(t, err)
	assert.NotNil(t, posts)
	assert.Len(t, posts.Items, 2)
}
