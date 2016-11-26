package metric_postgres

func (m PostgresMetric) Set(key string, value float64) {
	m.updateMetric(key, "=", value)
}

func (m PostgresMetric) Inc(key string) {
	m.updateMetric(key, "+", 1.0)
}

func (m PostgresMetric) Add(key string, value float64) {
	m.updateMetric(key, "+", value)
}
