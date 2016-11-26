package metric

type Gauge interface {
	// Set sets the Gauge to an arbitrary value.
	Set(string, float64)
	// Inc increments the Gauge by 1.
	Inc(string)
	// Dec decrements the Gauge by 1.
	Dec(string)
	// Add adds the given value to the Gauge. (The value can be
	// negative, resulting in a decrease of the Gauge.)
	Add(string, float64)
	// Sub subtracts the given value from the Gauge. (The value can be
	// negative, resulting in an increase of the Gauge.)
	Sub(string, float64)
}
