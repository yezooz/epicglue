package service

import "github.com/yezooz/common-cli/model"

func NewRedditService() *model.Service {
	return &model.Service{
		Name: Reddit,
	}
}
