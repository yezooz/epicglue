package worker_model

import "github.com/yezooz/epicglue/app/model"

type Processable interface {
	GetItem() *model.Item
	ProcessTask(*Task) error
}
