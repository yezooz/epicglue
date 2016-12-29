package store_redis_db

import (
	"github.com/yezooz/epicglue/app/connection/key_value_store"
	"github.com/yezooz/epicglue/app/connection/key_value_store/redis"
)

type RedisStore struct {
	redis key_value_store.KeyValueStore
}

func NewRedisStore() *RedisStore {
	return &RedisStore{
		redis: redis.NewRedis(),
	}
}

func NewTestRedisStore() *RedisStore {
	// TODO: connect to test db, provision if needed
	return &RedisStore{
		redis: redis.NewRedis(),
	}
}

func (r RedisStore) ItemsToProcess(tasks chan *worker_model.Task, params ...int) {
	key := "tasks"

	startValue := 0
	if len(params) > 0 {
		startValue = params[0]
	}

	items, startValue := r.redis.FindInSet(key, startValue)

	for _, item := range items {
		tasks <- worker_model.NewTaskFromString(item)
	}

	if len(items) > 0 {
		r.redis.RemoveFromSet(key, items...)
	}

	if startValue > 0 {
		r.ItemsToProcess(tasks, startValue)
	}
}

func (r RedisStore) ItemsToIndex(tasks chan *worker_model.Task, limit uint64) {
	panic("Don't use Redis for this query")
}

func (r RedisStore) MarkAsIndexed(task *worker_model.Task) error {
	panic("Don't use Redis for this query")
}

func (r RedisStore) MarkAsDeleted(task *worker_model.Task) error {
	panic("Don't use Redis for this query")
}

func (r RedisStore) MarkAsUndeleted(task *worker_model.Task) error {
	panic("Don't use Redis for this query")
}

func (r RedisStore) MarkAsGlued(task *worker_model.Task) error {
	panic("Don't use Redis for this query")
}

func (r RedisStore) MarkAsUnglued(task *worker_model.Task) error {
	panic("Don't use Redis for this query")
}

func (r RedisStore) MarkAsRead(task *worker_model.Task) error {
	panic("Don't use Redis for this query")
}

func (r RedisStore) MarkAsUnread(task *worker_model.Task) error {
	panic("Don't use Redis for this query")
}
