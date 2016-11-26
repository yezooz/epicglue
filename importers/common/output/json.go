package output

import (
	"github.com/dustin/gojson"
	"gitlab.com/epicglue/common-cli/model"
)

type JSONOutput struct {
}

func NewJSONOutput() *JSONOutput {
	return &JSONOutput{}
}

func (o JSONOutput) Post(item *model.Post) string {
	return o.parse(item)
}

func (o JSONOutput) Posts(items []*model.Post) string {
	return o.parse(items)
}

func (o JSONOutput) parse(input interface{}) string {
	data, err := json.Marshal(input)

	if err != nil {
		panic(err.Error())
	}

	return string(data)
}
