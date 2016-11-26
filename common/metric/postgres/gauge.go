package metric_postgres

func (m PostgresMetric) Dec(key string) {
	m.updateMetric(key, "+", -1.0)
}

func (m PostgresMetric) Sub(key string, value float64) {
	m.updateMetric(key, "+", -value)
}
