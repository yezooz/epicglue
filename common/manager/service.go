package manager

import "github.com/yezooz/epicglue/common/model"

type Service interface {
	Connect(*model.Token) error
	Disconnect(*model.Service, string) error
}
