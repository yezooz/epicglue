package service

import "gitlab.com/epicglue/common-cli/model"

func NewTwitterService() *model.Service {
	return &model.Service{
		Name: Twitter,
	}
}
