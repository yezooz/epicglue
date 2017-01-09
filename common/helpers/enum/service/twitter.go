package service

import "github.com/yezooz/epicglue/model"

func NewTwitterService() *model.Service {
	return &model.Service{
		Name: Twitter,
	}
}
