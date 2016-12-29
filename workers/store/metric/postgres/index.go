package store_metric_postgres

import (
	"fmt"
	"github.com/Sirupsen/logrus"
	"github.com/yezooz/epicglue/app/model"
	"github.com/yezooz/epicglue/app/worker/model"
)

func (m PostgresMetricStore) Indexed(task *worker_model.Task) {
	// General metrics
	m.metric = metric_postgres.NewPostgresMetric()
	m.metric.Inc("worker.indexed")
	m.metric.Inc(fmt.Sprintf("worker.%s.indexed", task.GetItem().GetService().ShortName))

	// Per-user metrics
	user := &model.User{
		Id: task.UserId,
	}

	m.metric = metric_postgres.NewPostgresMetricWithUser(user)
	m.metric.Inc("worker.indexed")
	m.metric.Inc(fmt.Sprintf("worker.%s.indexed", task.GetItem().GetService().ShortName))

	// For Logstash
	log.WithFields(logrus.Fields{
		"action":          "indexed_item",
		"user_id":         user.Id,
		"service":         task.GetItem().GetService().ShortName,
		"item_id":         task.ItemId,
		"subscription_id": task.SubscriptionId,
	}).Debug("Indexed")
}
