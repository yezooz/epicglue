package service

import "gitlab.com/epicglue/common-cli/model"

func NewRedditService() *model.Service {
	return &model.Service{
		Name: Reddit,
	}
}
