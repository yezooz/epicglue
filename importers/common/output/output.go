package output

import "gitlab.com/epicglue/common-cli/model"

type Output interface {
	Post(item *model.Post) string
	Posts(items []*model.Post) string
}
