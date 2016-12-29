package output

import "github.com/yezooz/common-cli/model"

type Output interface {
	Post(item *model.Post) string
	Posts(items []*model.Post) string
}
