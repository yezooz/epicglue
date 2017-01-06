package model

import "github.com/satori/go.uuid"

type Bucket struct {
	ID            uuid.UUID   `json:"id" meddler:"id"`
	InputBuckets  []uuid.UUID `json:"input_buckets" meddler:"input"`
	OutputBuckets []uuid.UUID `json:"output_buckets" meddler:"output"`
	Filter        string      `json:"filter" meddler:"filter"`
	IsEnabled     bool        `json:"is_enabled" meddler:"is_enabled"`
}
