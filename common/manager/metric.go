package manager

type MetricKey string
type MetricValue int64

type Metric interface {
	Increment(PipeID, MetricKey) error
	Decrement(PipeID, MetricKey) error
	Set(PipeID, MetricKey, MetricValue) error
}
