package store_metric_postgres

import (
	"github.com/yezooz/epicglue/app/helpers"
	"github.com/yezooz/epicglue/app/metric"
)

var log = helpers.GetLogger("process_metric")

type PostgresMetricStore struct {
	metric metric.Metric
}

func NewPostgresMetricStore() *PostgresMetricStore {
	return &PostgresMetricStore{
		metric: nil,
	}
}

func NewTestPostgresMetricStore() *PostgresMetricStore {
	// TODO: connect to test db, provision if needed
	return &PostgresMetricStore{
		metric: nil,
	}
}
