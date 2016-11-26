package product_hunt

import (
	"encoding/json"
	"github.com/pkg/errors"
	"gitlab.com/epicglue/common-cli/helpers"
	"net/http"
	"regexp"
)

var validDayFormat = regexp.MustCompile(`\d{4}-\d{2}-\d{2}`)

type CategoryName string

func (ph *ProductHuntRobot) getByEndpoint(endpoint string) ([]byte, error) {
	if ph.Token == "" {
		return nil, errors.New(NO_TOKEN_ERR)
	}

	req, err := http.NewRequest(http.MethodGet, BASE_URL+endpoint, nil)
	if err != nil {
		log.Error(err.Error())
		return nil, err
	}
	req.Header.Add("Authorization", "Bearer "+ph.Token)

	jsonResponse, err := helpers.DoAndReadResponse(ph.Client, req)
	if err != nil {
		log.Error(err.Error())
		return nil, err
	}

	return jsonResponse, nil
}

func (ph *ProductHuntRobot) posts(endpoint string) (*Items, error) {
	jsonResponse, err := ph.getByEndpoint(endpoint)

	if err != nil {
		log.Error(err.Error())
		return nil, err
	}

	items := Items{}
	if err := json.Unmarshal(jsonResponse, &items); err != nil {
		log.Error(err.Error())
		return nil, err
	}

	return &items, nil
}

func (ph *ProductHuntRobot) post(endpoint string) (*Item, error) {
	jsonResponse, err := ph.getByEndpoint(endpoint)

	if err != nil {
		log.Error(err.Error())
		return nil, err
	}

	item := struct {
		Item *Item `json:"post"`
	}{}
	if err := json.Unmarshal(jsonResponse, &item); err != nil {
		log.Error(err.Error())
		return nil, err
	}

	return item.Item, nil
}
