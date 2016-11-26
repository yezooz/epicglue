package elasticsearch_metric

import (
	"github.com/Sirupsen/logrus"
	"gitlab.com/epicglue/api/connection/index"
	"gitlab.com/epicglue/api/connection/index/elasticsearch"
	"gitlab.com/epicglue/api/helpers"
	"gitlab.com/epicglue/api/metric"
	"gitlab.com/epicglue/api/model"
	"time"
)

var log = helpers.GetLogger("metric")

type ElasticsearchMetric struct {
	user       *model.User
	connection index.Index
}

func NewElasticsearchMetric() metric.Metric {
	return ElasticsearchMetric{
		user:       nil,
		connection: elasticsearch.NewElasticsearch(),
	}
}

func NewElasticsearchMetricWithUser(user *model.User) metric.Metric {
	return ElasticsearchMetric{
		user:       user,
		connection: elasticsearch.NewElasticsearch(),
	}
}

func (m ElasticsearchMetric) SetUser(user *model.User) {
	m.user = user
}

func (m ElasticsearchMetric) updateMetric(key string, operator string, value float64) {
	if m.user != nil {
		m.updateMetricForUser(m.user, key, operator, value)
	} else {
		m.updateMetricWithoutUser(key, operator, value)
	}
}

func (m ElasticsearchMetric) updateMetricWithoutUser(key string, operator string, value float64) {
	log.WithFields(logrus.Fields{
		"key":      key,
		"value":    value,
		"operator": operator,
		"date":     time.Now().String(),
	}).Debug("Metric")
}

func (m ElasticsearchMetric) updateMetricForUser(user *model.User, key string, operator string, value float64) {
	log.WithFields(logrus.Fields{
		"user_id":  m.user.Id,
		"key":      key,
		"value":    value,
		"operator": operator,
		"date":     time.Now().String(),
	}).Debug("Metric")
}
