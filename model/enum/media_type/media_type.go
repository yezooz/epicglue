package media_type

type MediaType string

const (
	Link      MediaType = "link"
	Photo     MediaType = "photo"
	Video     MediaType = "video"
	Text      MediaType = "text"
	Event     MediaType = "event"
	Tweet     MediaType = "tweet"
	Payment   MediaType = "payment"
	Like      MediaType = "like"
	Comment   MediaType = "comment"
	Auction   MediaType = "auction"
	Crowdfund MediaType = "crowdfund"
)
