package worker_model

import "gitlab.com/epicglue/epicglue/app/model"

type Processable interface {
	GetItem() *model.Item
	ProcessTask(*Task) error
}
