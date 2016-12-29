package common

import (
	"github.com/yezooz/meta-cli/common/model"
	"net/url"
	"regexp"
)

type Filter interface {
	Register() *regexp.Regexp

	String(str string) map[string]*model.Metadata
	Url(link url.URL) *model.Metadata
}

// Register all filters
// Run against registered filters
