package server

import (
	"github.com/gin-gonic/gin"
	"github.com/yezooz/epicglue/api/store"
	"github.com/yezooz/epicglue/model"
)

func GetBucket(c *gin.Context) {
	bucket, err := store.GetBucket(c, stringIdToUuid(c.Param("id")))
	if err != nil {
		c.String(500, "Error getting bucket %s. %s", c.Param("id"), err)
	}
	c.JSON(200, bucket)
}

func GetBuckets(c *gin.Context) {
	buckets, err := store.GetBuckets(c)
	if err != nil {
		c.String(500, "Error getting buckets. %s", err)
	}
	c.JSON(200, buckets)
}

func CreateBucket(c *gin.Context) {
	bucket, exists := c.Get("bucket")
	if !exists {
		c.String(500, "CreateBucket expects bucket in context")
	}
	b := bucket.(model.Bucket)

	err := store.CreateBucket(c, &b)
	if err != nil {
		c.String(500, "Error creating bucket %s. %s", c.Param("id"), err)
	}
	c.JSON(200, b)
}

func UpdateBucket(c *gin.Context) {
	bucket, exists := c.Get("bucket")
	if !exists {
		c.String(500, "UpdateBucket expects bucket in context")
	}
	b := bucket.(model.Bucket)

	err := store.UpdateBucket(c, &b)
	if err != nil {
		c.String(500, "Error updating bucket %s. %s", c.Param("id"), err)
	}
	c.JSON(200, b)
}

func DeleteBucket(c *gin.Context) {
	bucket, exists := c.Get("bucket")
	if !exists {
		c.String(500, "DeleteBucket expects bucket in context")
	}
	b := bucket.(model.Bucket)

	err := store.DeleteBucket(c, &b)
	if err != nil {
		c.String(500, "Error deleting bucket %s. %s", c.Param("id"), err)
	}
	c.JSON(200, b)
}
