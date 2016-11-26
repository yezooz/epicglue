package store_metric_postgres

import (
	"fmt"
	"github.com/Sirupsen/logrus"
	"gitlab.com/epicglue/epicglue/app/model"
	"gitlab.com/epicglue/epicglue/app/worker/model"
)

func (m PostgresMetricStore) Glued(task *worker_model.Task) {
	// General metrics
	m.metric = metric_postgres.NewPostgresMetric()
	m.metric.Inc("worker.glued")
	m.metric.Inc(fmt.Sprintf("worker.%s.glued", task.GetItem().GetService().ShortName))

	// Per-user metrics
	user := &model.User{
		Id: task.UserId,
	}

	m.metric = metric_postgres.NewPostgresMetricWithUser(user)
	m.metric.Inc("worker.glued")
	m.metric.Inc(fmt.Sprintf("worker.%s.glued", task.GetItem().GetService().ShortName))

	// For Logstash
	log.WithFields(logrus.Fields{
		"action":  "glued_item",
		"user_id": user.Id,
		"service": task.GetItem().GetService().ShortName,
		"item_id": task.ItemId,
	}).Debug("Glued")
}

func (m PostgresMetricStore) Unglued(task *worker_model.Task) {
	// General metrics
	m.metric = metric_postgres.NewPostgresMetric()
	m.metric.Inc("worker.unglued")
	m.metric.Inc(fmt.Sprintf("worker.%s.unglued", task.GetItem().GetService().ShortName))

	// Per-user metrics
	user := &model.User{
		Id: task.UserId,
	}

	m.metric = metric_postgres.NewPostgresMetricWithUser(user)
	m.metric.Inc("worker.unglued")
	m.metric.Inc(fmt.Sprintf("worker.%s.unglued", task.GetItem().GetService().ShortName))

	// For Logstash
	log.WithFields(logrus.Fields{
		"action":  "unglued_item",
		"user_id": user.Id,
		"service": task.GetItem().GetService().ShortName,
		"item_id": task.ItemId,
	}).Debug("Unglued")
}
