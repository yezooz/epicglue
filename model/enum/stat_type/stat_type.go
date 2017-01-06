package stat_type

type StatType string

const (
	Karma     StatType = "karma"
	Following StatType = "following"
	Followers StatType = "followers"
	Posts     StatType = "posts"
	Comments  StatType = "comments"
	Liked     StatType = "liked"
	Listed    StatType = "listed"
)
