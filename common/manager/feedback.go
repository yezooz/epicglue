package manager

import "gitlab.com/epicglue/epicglue/app/model"

type Feedback interface {
	Create(model.Feedback) error
}
