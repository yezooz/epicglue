package service

import "github.com/yezooz/epicglue/common/model"

func NewHackerNewsService() *model.Service {
	return &model.Service{
		Name: HackerNews,
	}
}
