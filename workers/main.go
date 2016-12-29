package main

import (
	"github.com/yezooz/epicglue/app/config"
	"github.com/yezooz/epicglue/app/connection"
	"github.com/yezooz/epicglue/app/helpers"
	"time"
)

var (
	log   = helpers.GetLogger("worker")
	conf  = config.LoadConfig()
	tasks = make(chan *worker_model.Task, conf.App.TaskLimit)

	db     store_db.DBStore
	redis  store_db.DBStore
	index  store_index.IndexStore
	metric store_metric.MetricStore
)

func main() {
	connection.SystemCheck()

	db = store_db_postgres.NewPostgresStore()
	redis = store_redis_db.NewRedisStore()
	index = store_index_elasticsearch.NewElasticsearchIndexStore()
	metric = store_metric_postgres.NewPostgresMetricStore()

	var i int64
	for i = 0; i < conf.App.WorkerLimit; i++ {
		go worker(i, tasks)
	}

	// Looking for work
	for {
		db.ItemsToIndex(tasks, uint64(conf.App.IndexLimit))
		redis.ItemsToProcess(tasks)

		time.Sleep(5 * time.Second)
	}
}

func worker(workerNumber int64, tasks chan *worker_model.Task) {
	log.Infof("Worker %d spawned! [%s]", workerNumber, time.Now())

	for task := range tasks {
		switch task.TaskType {
		case worker_model.TaskTypeIndex:
			indexTask(task)
			break
		case worker_model.TaskTypeUpdate:
			updateTask(task)
			break
		case worker_model.TaskTypeDelete:
			deleteTask(task)
			break
		case worker_model.TaskTypeUndelete:
			undeleteTask(task)
			break
		case worker_model.TaskTypeGlue:
			glueTask(task)
			break
		case worker_model.TaskTypeUnglue:
			unglueTask(task)
			break
		case worker_model.TaskTypeRead:
			readTask(task)
			break
		case worker_model.TaskTypeUnread:
			unreadTask(task)
			break
		default:
			log.Panicf("Unknown task type: %d", task.TaskType)
		}
	}
}

func indexTask(task *worker_model.Task) {
	if err := index.IndexItem(task); err != nil {
		return
	}

	if err := db.MarkAsIndexed(task); err != nil {
		return
	}

	metric.Indexed(task)

	log.Debugf("%s for %d indexed", task.ItemId, task.UserId)
}

func updateTask(task *worker_model.Task) {
	if err := index.UpdateItem(task); err != nil {
		return
	}

	log.Debugf("%s for %d updated", task.ItemId, task.UserId)
}

func deleteTask(task *worker_model.Task) {
	if err := index.DeleteItem(task); err != nil {
		return
	}

	if err := db.MarkAsDeleted(task); err != nil {
		return
	}

	metric.Deleted(task)

	log.Debugf("%s for %d deleted", task.ItemId, task.UserId)
}

func undeleteTask(task *worker_model.Task) {
	if err := db.MarkAsUndeleted(task); err != nil {
		return
	}

	metric.Undeleted(task)

	log.Debugf("%s for %d deleted", task.ItemId, task.UserId)
}

func glueTask(task *worker_model.Task) {
	if err := index.UpdateItem(task); err != nil {
		return
	}

	if err := db.MarkAsGlued(task); err != nil {
		return
	}

	metric.Glued(task)

	log.Debugf("%s for %d glued", task.ItemId, task.UserId)
}

func unglueTask(task *worker_model.Task) {
	if err := index.UpdateItem(task); err != nil {
		return
	}

	if err := db.MarkAsUnglued(task); err != nil {
		return
	}

	metric.Unglued(task)

	log.Debugf("%s for %d unglued", task.ItemId, task.UserId)
}

func readTask(task *worker_model.Task) {
	if err := index.UpdateItem(task); err != nil {
		return
	}

	if err := db.MarkAsRead(task); err != nil {
		return
	}

	metric.Read(task)

	log.Debugf("%s for %d read", task.ItemId, task.UserId)
}

func unreadTask(task *worker_model.Task) {
	if err := index.UpdateItem(task); err != nil {
		return
	}

	if err := db.MarkAsUnread(task); err != nil {
		return
	}

	metric.Unread(task)

	log.Debugf("%s for %d unread", task.ItemId, task.UserId)
}
