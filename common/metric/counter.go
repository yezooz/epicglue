package metric

type Counter interface {
	// Set is used to set the Counter to an arbitrary value. It is only used
	// if you have to transfer a value from an external counter into this
	// Prometheus metric. Do not use it for regular handling of a
	// Prometheus counter (as it can be used to break the contract of
	// monotonically increasing values).
	Set(string, float64)
	// Inc increments the counter by 1.
	Inc(string)
	// Add adds the given value to the counter. It panics if the value is <
	// 0.
	Add(string, float64)
}
