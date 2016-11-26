package model

type Links struct {
	Default  string `json:"default"`
	Internal string `json:"internal,omitempty"`
	External string `json:"external,omitempty"`
}
