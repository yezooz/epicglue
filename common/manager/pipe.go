package manager

import "github.com/yezooz/epicglue/common/model"

type PipeID int64

type Pipe interface {
	Get(PipeID) (*model.Pipe, error)
	All() ([]model.Pipe, error)

	Create(model.Pipe) (*model.Pipe, error)
	Update(model.Pipe) (*model.Pipe, error)
	Delete(PipeID) error
}
