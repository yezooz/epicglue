package elasticsearch_metric

func (m ElasticsearchMetric) Set(key string, value float64) {
	m.updateMetric(key, "=", value)
}

func (m ElasticsearchMetric) Inc(key string) {
	m.updateMetric(key, "+", 1.0)
}

func (m ElasticsearchMetric) Add(key string, value float64) {
	m.updateMetric(key, "+", value)
}
