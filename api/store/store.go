package store

import (
	"context"
	"github.com/satori/go.uuid"
	"github.com/yezooz/epicglue/model"
	"github.com/yezooz/meddler"
)

type Store interface {
	meddler.DB

	GetBucket(uuid.UUID) (*model.Bucket, error)
	GetBuckets() ([]*model.Bucket, error)
	CreateBucket(*model.Bucket) error
	UpdateBucket(*model.Bucket) error
	DeleteBucket(*model.Bucket) error
}

func GetBucket(c context.Context, id uuid.UUID) (*model.Bucket, error) {
	return FromContext(c).GetBucket(id)
}

func GetBuckets(c context.Context) ([]*model.Bucket, error) {
	return FromContext(c).GetBuckets()
}

func CreateBucket(c context.Context, bucket *model.Bucket) error {
	return FromContext(c).CreateBucket(bucket)
}

func UpdateBucket(c context.Context, bucket *model.Bucket) error {
	return FromContext(c).UpdateBucket(bucket)
}

func DeleteBucket(c context.Context, bucket *model.Bucket) error {
	return FromContext(c).DeleteBucket(bucket)
}
