package model

type Location struct {
	Name *string  `json:"name,omitempty" gorethink:"name"`
	Lat  *float64 `json:"lat,omitempty" gorethink:"lat"`
	Lon  *float64 `json:"lon,omitempty" gorethink:"lon"`
}
