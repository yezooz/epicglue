package model

type Media struct {
	Original  *Medium `json:"original,omitempty" gorethink:"original"`
	Large     *Medium `json:"large,omitempty" gorethink:"large"`
	Medium    *Medium `json:"medium,omitempty" gorethink:"medium"`
	Small     *Medium `json:"small,omitempty" gorethink:"small"`
	Thumbnail *Medium `json:"thumbnail,omitempty" gorethink:"thumbnail"`
}

type Medium struct {
	Url      string  `json:"url" gorethink:"url"`
	CacheUrl string  `json:"cache_url,omitempty" gorethink:"cache_url"`
	Width    int64   `json:"width,omitempty" gorethink:"width"`
	Height   int64   `json:"height,omitempty" gorethink:"height"`
	Preview  *Medium `json:"preview,omitempty" gorethink:"preview"`
}
