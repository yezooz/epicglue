package service

import "gitlab.com/epicglue/common-cli/model"

func NewHackerNewsService() *model.Service {
	return &model.Service{
		Name: HackerNews,
	}
}
