package manager

import "github.com/yezooz/epicglue/common/model"

type Token interface {
	Token(model.User) (string, error)
}
