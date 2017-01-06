package item_type

type ItemType string

const (
	InstagramPost      ItemType = "instagram.post"
	InstagramPopular   ItemType = "instagram.popular"
	InstagramLocation  ItemType = "instagram.location"
	InstagramLike      ItemType = "instagram.like"
	InstagramComment   ItemType = "instagram.comment"
	InstagramFollowing ItemType = "instagram.following"
	InstagramFollower  ItemType = "instagram.follower"

	HackerNewsPost ItemType = "hacker_news.post"
	HackerNewsShow ItemType = "hacker_news.show"
	HackerNewsAsk  ItemType = "hacker_news.ask"

	ProductHuntPost ItemType = "producthunt.post"

	KickstarterAuction ItemType = "kickstarter.auction"
)
