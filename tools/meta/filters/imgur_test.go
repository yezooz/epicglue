package filters

import (
	"fmt"
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestImgurLinkMatcher(t *testing.T) {
	for _, link := range []string{
		"http://i.imgur.com/s1HsWYD.jpg",
		"https://i.imgur.com/os6shXP.png",
		"i.imgur.com/6.png",
		"i.imgur.com/o.apng",
		"i.imgur.com/D.jpeg",
		"i.imgur.com/D.gif",
		"i.imgur.com/D.gifv",
	} {
		assert.True(t, IMGUR.MatchString(link), fmt.Sprintf("%q should be valid", link))
	}
}
