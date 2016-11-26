package model

type Device struct {
	Name string `json:"name" gorethink:"name"`
	UDID string `json:"udid" gorethink:"udid"`
}
