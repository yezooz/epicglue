package store_index_elasticsearch

// TODO: use item/store implementation
func (inx ElasticsearchStore) DeleteItem(task *worker_model.Task) error {
	if err := inx.Connection.Delete(task.IndexName(), task.ItemId); err != nil {
		return err
	}

	return nil
}
