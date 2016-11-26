package filters

import (
	"regexp"
	"strings"
)

var SUPPORTED_DOMAINS string = `com|io|pl`

// https://gist.github.com/dperini/729294
var FULL_LINK *regexp.Regexp = regexp.MustCompile(`(?:(?:https?)://)(?:\S+(?::\S*)?@|\d{1,3}(?:\.\d{1,3}){3}|(?:(?:[a-z\d\x{00a1}-\x{ffff}]+-?)*[a-z\d\x{00a1}-\x{ffff}]+)(?:\.(?:[a-z\d\x{00a1}-\x{ffff}]+-?)*[a-z\d\x{00a1}-\x{ffff}]+)*(?:\.[a-z\x{00a1}-\x{ffff}]{2,6}))(?::\d+)?(?:[^\s]*)`)
var PARTIAL_LINK *regexp.Regexp = regexp.MustCompile(`(?:\S+(?::\S*)?@|\d{1,3}(?:\.\d{1,3}){3}|(?:(?:[a-z\d\x{00a1}-\x{ffff}]+-?)*[a-z\d\x{00a1}-\x{ffff}]+)(?:\.(?:[a-z\d\x{00a1}-\x{ffff}]+-?)*[a-z\d\x{00a1}-\x{ffff}]+)*(?:\.(?:` + SUPPORTED_DOMAINS + `)+))(?::\d+)?(?:[^\s]*)`)

func findLinks(str string) []string {
	var links []string = make([]string, 0)

	for _, link := range FULL_LINK.FindAllStringSubmatch(str, -1) {
		links = append(links, link[0])

		str = strings.Replace(str, link[0], "", 1)
	}

	for _, link := range PARTIAL_LINK.FindAllStringSubmatch(str, -1) {
		// HTTP or HTTPS?
		links = append(links, link[0])
	}

	return links
}
