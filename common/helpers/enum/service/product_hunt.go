package service

import "github.com/yezooz/epicglue/model"

func NewProductHuntService() *model.Service {
	return &model.Service{
		Name: ProductHunt,
	}
}
