package filters

import (
	"github.com/yezooz/meta-cli/common/model"
	"log"
	"net/http"
	"net/url"
)

type Expander struct {
}

func (e Expander) expand(link *url.URL) *url.URL {
	resp, err := http.Get(link.String())
	if err != nil {
		log.Fatalf("http.Get => %v", err.Error())
	}

	return resp.Request.URL
}

func (e Expander) String(str string) map[string]*model.Metadata {
	parsed := make(map[string]*model.Metadata)

	for _, link := range findLinks(str) {
		linkUrl, err := url.Parse(link)

		if err != nil {

		}

		parsed[link] = e.Url(linkUrl)
	}

	return parsed
}

func (e Expander) Url(link *url.URL) *model.Metadata {
	// TODO
	return &model.Metadata{
		URL: e.expand(link),
	}
}
