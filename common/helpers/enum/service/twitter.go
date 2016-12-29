package service

import "github.com/yezooz/common-cli/model"

func NewTwitterService() *model.Service {
	return &model.Service{
		Name: Twitter,
	}
}
