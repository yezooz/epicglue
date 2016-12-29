package service

import "github.com/yezooz/common-cli/model"

func NewProductHuntService() *model.Service {
	return &model.Service{
		Name: ProductHunt,
	}
}
