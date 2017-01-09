package service

import "github.com/yezooz/epicglue/model"

func NewHackerNewsService() *model.Service {
	return &model.Service{
		Name: HackerNews,
	}
}
