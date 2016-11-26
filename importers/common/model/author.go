package model

type Author struct {
	Name     string `json:"name"`
	FullName string `json:"full_name,omitempty"`
	Media    *Media `json:"media,omitempty"`
}
