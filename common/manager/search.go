package manager

import (
	"gitlab.com/epicglue/epicglue/app/model"
)

type Search interface {
	Search(model.SearchQuery) ([]*model.Item, error)
}
