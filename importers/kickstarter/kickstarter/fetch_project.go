package kickstarter

import (
	"github.com/PuerkitoBio/goquery"
	"github.com/spf13/cast"
	"net/http"
)

func (k *KickstarterRobot) itemByUrl(url string) (*Item, error) {
	req, err := http.NewRequest(http.MethodGet, url, nil)
	if err != nil {
		log.Error(err.Error())
		return nil, err
	}

	res, err := k.Client.Do(req)
	if err != nil {
		log.Error(err.Error())
		return nil, err
	}

	doc, err := goquery.NewDocumentFromResponse(res)
	if err != nil {
		log.Fatal(err.Error())
		return nil, err
	}

	var (
		goal    string
		pledged string
		state   string
	)

	doc.Find("div[data-goal]").Each(func(i int, s *goquery.Selection) {
		goal, _ = s.Attr("data-goal")
		pledged, _ = s.Attr("data-pledged")
	})

	doc.Find("section[data-project-state]").Each(func(i int, s *goquery.Selection) {
		state, _ = s.Attr("data-project-state")
	})

	return &Item{
		Goal:    cast.ToFloat64(goal),
		Pledged: cast.ToFloat64(pledged),
		State:   state,
	}, nil
}
