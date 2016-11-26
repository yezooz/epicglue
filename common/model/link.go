package model

type Links struct {
	Default  string  `json:"default" gorethink:"default"`
	Internal *string `json:"internal,default,omitempty" gorethink:"internal"`
	External *string `json:"external,default,omitempty" gorethink:"external"`
}
