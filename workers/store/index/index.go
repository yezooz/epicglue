package store_index

import "github.com/yezooz/epicglue/workers/model"

type IndexStore interface {
	IndexItem(*worker_model.Task) error
	UpdateItem(*worker_model.Task) error
	DeleteItem(*worker_model.Task) error

	//IndexItemBulk(...indexer.IndexableItem) []error
	//UpdateItemBulk(...indexer.IndexableItem) []error
}
