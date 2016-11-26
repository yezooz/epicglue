package worker_model

import "time"

type updateItem struct {
	Points    int64      `json:"points,omitempty"`
	Comments  int64      `json:"comments,omitempty"`
	UpdatedAt *time.Time `json:"updated_at,omitempty"`
	SubIdList []string   `json:"subs,omitempty"`
}
