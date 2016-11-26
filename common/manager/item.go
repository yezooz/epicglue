package manager

import "github.com/yezooz/epicglue/common/model"

type ItemID string

type Item interface {
	Create(model.Item) (*model.Item, error)
	Update(model.Item) (*model.Item, error)
	Delete(ItemID) error
}
