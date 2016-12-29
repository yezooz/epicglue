package model

import (
	"github.com/yezooz/common-cli/model"
	"net/url"
)

type Metadata struct {
	Media       *model.Media
	Title       string
	Description string
	URL         *url.URL
}
