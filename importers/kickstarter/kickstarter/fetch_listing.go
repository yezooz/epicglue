package kickstarter

import (
	"encoding/json"
	"gitlab.com/epicglue/common-cli/helpers"
	"net/http"
)

func (k *KickstarterRobot) getByEndpoint(endpoint string) ([]byte, error) {
	req, err := http.NewRequest(http.MethodGet, BASE_URL+endpoint, nil)
	if err != nil {
		log.Error(err.Error())
		return nil, err
	}

	jsonResponse, err := helpers.DoAndReadResponse(k.Client, req)
	if err != nil {
		log.Error(err.Error())
		return nil, err
	}

	return jsonResponse, nil
}

func (k *KickstarterRobot) itemsByCategory(category string, sort string) (*Items, error) {
	jsonResponse, err := k.getByEndpoint("&category_id=" + category + "&sort=" + sort)

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
