package manager

import "github.com/yezooz/epicglue/common/model"

type Media interface {
	Create(model.Item, model.Media)
	Delete(model.Item, model.Media)
}
