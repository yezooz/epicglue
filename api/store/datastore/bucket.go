package datastore

import (
	"github.com/satori/go.uuid"
	"github.com/yezooz/epicglue/model"
)

func (db *datastore) GetBucket(id uuid.UUID) (*model.Bucket, error) {
	panic("implement me")
}

func (db *datastore) GetBuckets() ([]*model.Bucket, error) {
	//TODO: panic("implement me")

	return make([]*model.Bucket, 0), nil
}

func (db *datastore) CreateBucket(*model.Bucket) error {
	panic("implement me")
}

func (db *datastore) UpdateBucket(*model.Bucket) error {
	panic("implement me")
}

func (db *datastore) DeleteBucket(*model.Bucket) error {
	panic("implement me")
}
