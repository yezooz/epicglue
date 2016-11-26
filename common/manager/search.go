package manager

import "github.com/yezooz/epicglue/common/model"

type Search interface {
	Search(model.SearchQuery) ([]*model.Item, error)
}
