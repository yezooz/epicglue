package filters

import "regexp"

var IMGUR = regexp.MustCompile(`^(http|https)?(:\/\/)?i\.imgur\.com/[[:alnum:]]+\.(jpg|jpeg|png|apng|gif|gifv){1}$`)

type ImgurFilter struct {
}
