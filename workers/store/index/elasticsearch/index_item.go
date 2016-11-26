package store_index_elasticsearch

import (
	"fmt"
)

func (inx ElasticsearchStore) IndexItem(task *worker_model.Task) error {
	if err := inx.addToIndex(task); err != nil {
		return err
	}

	if err := inx.addToSubIdList(task); err != nil {
		return err
	}

	return nil
}

func (inx ElasticsearchStore) addToIndex(task *worker_model.Task) error {
	ttl := ""
	if task.TTL > 0 {
		ttl = fmt.Sprintf("%dd", task.TTL)
	}

	query := fmt.Sprintf(`{"doc":%s,"upsert":%s}`, task.UpdateJSON(), task.InsertJSON())

	if err := inx.Connection.UpdateWithTTL(task.IndexName(), task.ItemId, ttl, query); err != nil {
		return err
	}

	return nil
}

func (inx ElasticsearchStore) addToSubIdList(task *worker_model.Task) error {
	return inx.Connection.AddIntToList(task.IndexName(), task.ItemId, "subs", task.SubscriptionId)
}
