package metric_postgres

import (
	"github.com/Sirupsen/logrus"
	"github.com/jinzhu/gorm"
	"github.com/uber-go/zap"
	"github.com/yezooz/api/connection/database/postgres"
	"github.com/yezooz/api/metric"
	"github.com/yezooz/api/model"
	"runtime/debug"
	"time"
)

var log = zap.New(zap.NewJSONEncoder())

type PostgresMetric struct {
	user       *model.User
	connection *gorm.DB
}

func NewPostgresMetric() metric.Metric {
	return PostgresMetric{
		user:       nil,
		connection: postgres.NewPostgres(),
	}
}

func NewPostgresMetricWithUser(user *model.User) metric.Metric {
	return PostgresMetric{
		user:       user,
		connection: postgres.NewPostgres(),
	}
}

func (m PostgresMetric) SetUser(user *model.User) {
	m.user = user
}

func (m PostgresMetric) updateMetric(key string, operator string, value float64) {
	if m.user != nil {
		m.updateMetricForUser(m.user, key, operator, value)
	} else {
		m.updateMetricWithoutUser(key, operator, value)
	}
}

func (m PostgresMetric) updateMetricWithoutUser(key string, operator string, value float64) {
	start := time.Now()

	var query string
	if operator == "=" {
		query = `
            INSERT INTO
                user_metric (key, value, created_at, updated_at)
            VALUES
                ($2, $1, NOW(), NOW())
            ON CONFLICT (user_id, key) DO UPDATE SET value = $1, updated_at = NOW()
        `
	} else {
		query = `
            INSERT INTO
                user_metric (key, value, created_at, updated_at)
            VALUES
                ($2, $1, NOW(), NOW())
            ON CONFLICT (user_id, key) DO UPDATE SET value = user_metric.value + $1, updated_at = NOW()
        `
	}

	if _, err := m.connection.DB().Exec(query, value, key); err != nil {
		log.WithFields(logrus.Fields{
			"stack":    string(debug.Stack()),
			"query":    query,
			"value":    value,
			"took":     time.Since(start),
			"took_str": time.Since(start).String(),
		}).Error(err)
	}
}

func (m PostgresMetric) updateMetricForUser(user *model.User, key string, operator string, value float64) {
	start := time.Now()

	var query string
	if operator == "=" {
		query = `
            INSERT INTO
                user_metric (user_id, key, value, created_at, updated_at)
            VALUES
                ($1, $2, $3, NOW(), NOW())
            ON CONFLICT (user_id, key) DO UPDATE SET value = $3, updated_at = NOW()
        `
	} else {
		query = `
            INSERT INTO
                user_metric (user_id, key, value, created_at, updated_at)
            VALUES
                ($1, $2, $3, NOW(), NOW())
            ON CONFLICT (user_id, key) DO UPDATE SET value = user_metric.value + $3, updated_at = NOW()
        `
	}

	if _, err := m.connection.DB().Exec(query, m.user.Id, key, value); err != nil {
		log.WithFields(logrus.Fields{
			"stack":    string(debug.Stack()),
			"query":    query,
			"user_id":  m.user.Id,
			"key":      key,
			"value":    value,
			"took":     time.Since(start),
			"took_str": time.Since(start).String(),
		}).Error(err)
	}
}
