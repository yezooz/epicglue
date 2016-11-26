package store_index

type IndexStore interface {
	IndexItem(*worker_model.Task) error
	UpdateItem(*worker_model.Task) error
	DeleteItem(*worker_model.Task) error

	//IndexItemBulk(...indexer.IndexableItem) []error
	//UpdateItemBulk(...indexer.IndexableItem) []error
}
