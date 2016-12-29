package hacker_news

import (
	"encoding/json"
	"fmt"
	"github.com/yezooz/epicglue/importers/common/helpers"
	"html"
	"net/http"
	"strings"
)

type CategoryName string

func (hn *HackerNewsRobot) getByEndpoint(endpoint string) ([]byte, error) {
	req, err := http.NewRequest(http.MethodGet, BASE_URL+endpoint+".json", nil)
	if err != nil {
		log.Error(err.Error())
		return nil, err
	}

	jsonResponse, err := helpers.DoAndReadResponse(hn.Client, req)
	if err != nil {
		log.Error(err.Error())
		return nil, err
	}

	return jsonResponse, nil
}

func (hn *HackerNewsRobot) posts(endpoint string) ([]*Item, error) {
	jsonResponse, err := hn.getByEndpoint(endpoint)

	if err != nil {
		log.Error(err.Error())
		return nil, err
	}

	var itemIds []int
	if err := json.Unmarshal(jsonResponse, &itemIds); err != nil {
		log.Error(err.Error())
		return nil, err
	}

	items := make([]*Item, 0)
	for i, itemId := range itemIds {
		if hn.Limit > 0 && i >= hn.Limit {
			break
		}

		item, err := hn.ById(itemId)

		if err != nil {
			log.Error(err.Error())
			return nil, err
		}

		items = append(items, item)
	}

	return items, nil
}

func (hn *HackerNewsRobot) post(endpoint string) (*Item, error) {
	jsonResponse, err := hn.getByEndpoint(endpoint)

	if err != nil {
		log.Error(err.Error())
		return nil, err
	}

	item := Item{}
	if err := json.Unmarshal(jsonResponse, &item); err != nil {
		log.Error(err.Error())
		return nil, err
	}

	if item.URL == "" {
		item.URL = fmt.Sprintf("https://news.ycombinator.com/item?id=%d", item.Id)
	}

	if item.Description != "" {
		item.Description = html.UnescapeString(item.Description)
		item.Description = strings.Replace(item.Description, "<p>", "\n\n", -1)
	}

	return &item, nil
}
