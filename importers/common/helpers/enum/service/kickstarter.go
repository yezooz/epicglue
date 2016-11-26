package service

import "gitlab.com/epicglue/common-cli/model"

func NewKickstarterService() *model.Service {
	return &model.Service{
		Name: Kickstarter,
	}
}
