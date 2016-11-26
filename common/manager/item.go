package manager

import "gitlab.com/epicglue/epicglue/app/model"

type ItemID string

type Item interface {
	Create(model.Item) (*model.Item, error)
	Update(model.Item) (*model.Item, error)
	Delete(ItemID) error
}
