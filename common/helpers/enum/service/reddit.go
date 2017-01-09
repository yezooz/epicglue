package service

import "github.com/yezooz/epicglue/model"

func NewRedditService() *model.Service {
	return &model.Service{
		Name: Reddit,
	}
}
