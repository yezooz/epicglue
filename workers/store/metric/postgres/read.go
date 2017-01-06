package store_metric_postgres

import (
	"fmt"
	"github.com/Sirupsen/logrus"
	"github.com/yezooz/epicglue/app/model"
	"github.com/yezooz/epicglue/app/worker/model"
	"github.com/yezooz/epicglue/common/metric/postgres"
	"github.com/yezooz/epicglue/workers/model"
)

func (m PostgresMetricStore) Read(task *worker_model.Task) {
	// General metrics
	m.metric = metric_postgres.NewPostgresMetric()
	m.metric.Inc("worker.read")
	m.metric.Inc(fmt.Sprintf("worker.%s.read", task.GetItem().GetService().ShortName))

	// Per-user metrics
	user := &model.User{
		Id: task.UserId,
	}

	m.metric = metric_postgres.NewPostgresMetricWithUser(user)
	m.metric.Inc("worker.read")
	m.metric.Inc(fmt.Sprintf("worker.%s.read", task.GetItem().GetService().ShortName))

	// For Logstash
	log.WithFields(logrus.Fields{
		"action":  "read_item",
		"user_id": user.Id,
		"service": task.GetItem().GetService().ShortName,
		"item_id": task.ItemId,
	}).Debug("Read")
}

func (m PostgresMetricStore) Unread(task *worker_model.Task) {
	// General metrics
	m.metric = metric_postgres.NewPostgresMetric()
	m.metric.Inc("worker.unread")
	m.metric.Inc(fmt.Sprintf("worker.%s.unread", task.GetItem().GetService().ShortName))

	// Per-user metrics
	user := &model.User{
		Id: task.UserId,
	}

	m.metric = metric_postgres.NewPostgresMetricWithUser(user)
	m.metric.Inc("worker.unread")
	m.metric.Inc(fmt.Sprintf("worker.%s.unread", task.GetItem().GetService().ShortName))

	// For Logstash
	log.WithFields(logrus.Fields{
		"action":  "unread_item",
		"user_id": user.Id,
		"service": task.GetItem().GetService().ShortName,
		"item_id": task.ItemId,
	}).Debug("Unread")
}
