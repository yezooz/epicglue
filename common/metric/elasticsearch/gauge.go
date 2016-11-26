package elasticsearch_metric

func (m ElasticsearchMetric) Dec(key string) {
	m.updateMetric(key, "+", -1.0)
}

func (m ElasticsearchMetric) Sub(key string, value float64) {
	m.updateMetric(key, "+", -value)
}
