package store_metric_postgres

import (
	"fmt"
	"github.com/Sirupsen/logrus"
	"github.com/yezooz/epicglue/app/model"
	"github.com/yezooz/epicglue/app/worker/model"
)

func (m PostgresMetricStore) Deleted(task *worker_model.Task) {
	// General metrics
	m.metric = metric_postgres.NewPostgresMetric()
	m.metric.Inc("worker.deleted")
	m.metric.Inc(fmt.Sprintf("worker.%s.deleted", task.GetItem().GetService().ShortName))

	// Per-user metrics
	user := &model.User{
		Id: task.UserId,
	}

	m.metric = metric_postgres.NewPostgresMetricWithUser(user)
	m.metric.Inc("worker.deleted")
	m.metric.Inc(fmt.Sprintf("worker.%s.deleted", task.GetItem().GetService().ShortName))

	// For Logstash
	log.WithFields(logrus.Fields{
		"action":  "deleted_item",
		"user_id": user.Id,
		"service": task.GetItem().GetService().ShortName,
		"item_id": task.ItemId,
	}).Debug("Deleted")
}

func (m PostgresMetricStore) Undeleted(task *worker_model.Task) {
	// General metrics
	m.metric = metric_postgres.NewPostgresMetric()
	m.metric.Inc("worker.undeleted")
	m.metric.Inc(fmt.Sprintf("worker.%s.undeleted", task.GetItem().GetService().ShortName))

	// Per-user metrics
	user := &model.User{
		Id: task.UserId,
	}

	m.metric = metric_postgres.NewPostgresMetricWithUser(user)
	m.metric.Inc("worker.undeleted")
	m.metric.Inc(fmt.Sprintf("worker.%s.undeleted", task.GetItem().GetService().ShortName))

	// For Logstash
	log.WithFields(logrus.Fields{
		"action":  "undeleted_item",
		"user_id": user.Id,
		"service": task.GetItem().GetService().ShortName,
		"item_id": task.ItemId,
	}).Debug("Undeleted")
}
