package manager

import "gitlab.com/epicglue/epicglue/app/model"

type UserID int64

type User interface {
	Get(UserID) (*model.User, error)
	Create(model.User) error
	Update(model.User) error
	Delete(UserID) error
}
