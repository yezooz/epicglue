package manager

import "github.com/yezooz/epicglue/common/model"

type Feedback interface {
	Create(model.Feedback) error
}
