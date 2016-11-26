package manager

import "gitlab.com/epicglue/epicglue/app/model"

type Token interface {
	Token(model.User) (string, error)
}
