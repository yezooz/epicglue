package manager

import "github.com/yezooz/epicglue/common/model"

type Channel interface {
	Get(int64) (*model.Channel, error)
	All() ([]model.Channel, error)

	Create(model.Channel) (*model.Channel, error)
	Update(model.Channel) (*model.Channel, error)
	Delete(int64) error
}
