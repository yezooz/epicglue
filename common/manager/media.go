package manager

import "gitlab.com/epicglue/epicglue/app/model"

type Media interface {
	Create(model.Item, model.Media)
	Delete(model.Item, model.Media)
}
