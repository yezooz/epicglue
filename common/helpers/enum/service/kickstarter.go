package service

import "github.com/yezooz/epicglue/model"

func NewKickstarterService() *model.Service {
	return &model.Service{
		Name: Kickstarter,
	}
}
