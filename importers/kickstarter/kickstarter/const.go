package kickstarter

const (
	SortByMagic      = "magic"
	SortByPopularity = "popularity"
	SortByDate       = "newest"
	SortByEndDate    = "end_date"
	SortByMostFunded = "most_funded"

	StateLive       = "live"
	StateSuccessful = "successful"
	StateFailed     = "failed"

	AmountLessThan1k        = 0
	AmountBetween1kAnd10k   = 1
	AmountBetween10kAnd100k = 2
	AmountBetween100kAnd1m  = 3
	AmountOver1m            = 4

	RaisedLessThan75      = 0
	RaisedBetween75And100 = 1
	RaisedOver100         = 2
)
