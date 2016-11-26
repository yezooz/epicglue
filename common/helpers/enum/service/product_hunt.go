package service

import "gitlab.com/epicglue/common-cli/model"

func NewProductHuntService() *model.Service {
	return &model.Service{
		Name: ProductHunt,
	}
}
