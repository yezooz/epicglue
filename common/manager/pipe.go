package manager

import "gitlab.com/epicglue/epicglue/app/model"

type PipeID int64

type Pipe interface {
	Get(PipeID) (*model.Pipe, error)
	All() ([]model.Pipe, error)

	Create(model.Pipe) (*model.Pipe, error)
	Update(model.Pipe) (*model.Pipe, error)
	Delete(PipeID) error
}
