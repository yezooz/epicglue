package store_metric

type MetricStore interface {
	Indexed(*worker_model.Task)
	Deleted(*worker_model.Task)
	Undeleted(*worker_model.Task)
	Glued(*worker_model.Task)
	Unglued(*worker_model.Task)
	Read(*worker_model.Task)
	Unread(*worker_model.Task)
}
