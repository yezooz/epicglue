package model

type Location struct {
	Lat     float64 `json:"lat,omitempty"`
	Lon     float64 `json:"lon,omitempty"`
	Name    string  `json:"name,omitempty"`
	Details string  `json:"details,omitempty"`
}
