package output

import (
	"fmt"
	"github.com/yezooz/common-cli/model"
	"strings"
)

type RawOutput struct {
}

func NewRawOutput() *RawOutput {
	return &RawOutput{}
}

func (o RawOutput) Post(item *model.Post) string {
	return fmt.Sprintf("\n\n%+v", item)
}

func (o RawOutput) Posts(items []*model.Post) string {
	var str []string

	for _, item := range items {
		str = append(str, o.Post(item))
	}

	return strings.Join(str, "\n\n---\n")
}
