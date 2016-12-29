package reddit

import (
	"encoding/json"
	"github.com/yezooz/common-cli/helpers"
	"net/http"
)

func (r *RedditRobot) getByEndpoint(endpoint string) ([]byte, error) {
	req, err := http.NewRequest(http.MethodGet, BASE_URL+endpoint+".json", nil)
	if err != nil {
		log.Error(err.Error())
		return nil, err
	}
	req.Header.Add("User-Agent", USER_AGENT)

	jsonResponse, err := helpers.DoAndReadResponse(r.Client, req)
	if err != nil {
		log.Error(err.Error())
		return nil, err
	}

	return jsonResponse, nil
}

func (r *RedditRobot) post(endpoint string) (*Post, error) {
	jsonResponse, err := r.getByEndpoint(endpoint)
	if err != nil {
		return nil, err
	}

	item := Post{}
	if err := json.Unmarshal(jsonResponse, &item); err != nil {
		log.Error(err.Error())
		return nil, err
	}

	return &item, nil
}

func (r *RedditRobot) posts(endpoint string) (*Posts, error) {
	jsonResponse, err := r.getByEndpoint(endpoint)
	if err != nil {
		return nil, err
	}

	items := Posts{}
	if err := json.Unmarshal(jsonResponse, &items); err != nil {
		log.Error(err.Error())
		return nil, err
	}

	return &items, nil
}
