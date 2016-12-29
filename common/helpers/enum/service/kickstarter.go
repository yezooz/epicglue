package service

import "github.com/yezooz/common-cli/model"

func NewKickstarterService() *model.Service {
	return &model.Service{
		Name: Kickstarter,
	}
}
