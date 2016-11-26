package manager

import "gitlab.com/epicglue/epicglue/app/model"

type Service interface {
	Connect(*model.Token) error
	Disconnect(*model.Service, string) error
}
