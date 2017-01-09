package service

import "github.com/yezooz/epicglue/importers/common/model"

func NewKickstarterService() *model.Service {
	return &model.Service{
		Name: Kickstarter,
	}
}
