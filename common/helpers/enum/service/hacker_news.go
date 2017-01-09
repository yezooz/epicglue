package service

import "github.com/yezooz/epicglue/importers/common/model"

func NewHackerNewsService() *model.Service {
	return &model.Service{
		Name: HackerNews,
	}
}
