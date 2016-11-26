package model

type Media struct {
	Type      string  `json:"type"`
	Original  *Medium `json:"original,omitempty"`
	Large     *Medium `json:"large,omitempty"`
	Medium    *Medium `json:"medium,omitempty"`
	Small     *Medium `json:"small,omitempty"`
	Thumbnail *Medium `json:"thumbnail,omitempty"`
}

type Medium struct {
	URL     string `json:"url"`
	Width   int    `json:"width,omitempty"`
	Height  int    `json:"height,omitempty"`
	Preview *Media `json:"preview,omitempty"`
}
