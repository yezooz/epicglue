package store_db

// TODO: This model clearly doesn't work. DB and Redis hold different functions but are both for storage.

type DBStore interface {
	ItemsToIndex(tasks chan *worker_model.Task, limit uint64)
	ItemsToProcess(tasks chan *worker_model.Task, params ...int)

	MarkAsIndexed(task *worker_model.Task) error
	MarkAsDeleted(task *worker_model.Task) error
	MarkAsUndeleted(task *worker_model.Task) error

	MarkAsGlued(task *worker_model.Task) error
	MarkAsUnglued(task *worker_model.Task) error

	MarkAsRead(task *worker_model.Task) error
	MarkAsUnread(task *worker_model.Task) error
}
