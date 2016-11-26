package store_index_elasticsearch

func (inx ElasticsearchStore) UpdateItem(task *worker_model.Task) error {
	switch task.TaskType {
	case worker_model.TaskTypeRead:
		return inx.Connection.Update(task.IndexName(), task.ItemId, `{"doc": {"read":true}}`)
	case worker_model.TaskTypeUnread:
		return inx.Connection.RemoveField(task.IndexName(), task.ItemId, "read")
	case worker_model.TaskTypeGlue:
		return inx.Connection.Update(task.IndexName(), task.ItemId, `{"doc": {"glued":true}}`)
	case worker_model.TaskTypeUnglue:
		return inx.Connection.RemoveField(task.IndexName(), task.ItemId, "glued")
	case worker_model.TaskTypeUpdate:
		return inx.Connection.Update(task.IndexName(), task.ItemId, string(task.UpdateJSON()))
	}

	panic("Was not sure what to update as task type was not found")
}
