// +build integration

package metric_postgres_test

import (
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestDec(t *testing.T) {
	user, key := makeTestData()

	metric := metric_postgres.NewPostgresMetricWithUser(user)
	metric.Set(key, 2)

	metric.Dec(key)

	if value, err := checkMetric(user.Id, key); err != nil {
		t.Error(err)
	} else {
		assert.Equal(t, 1.0, value)
	}

	metric.Dec(key)

	if value, err := checkMetric(user.Id, key); err != nil {
		t.Error(err)
	} else {
		assert.Equal(t, 0.0, value)
	}
}

func TestDecNoUser(t *testing.T) {

}

func TestSub(t *testing.T) {
	user, key := makeTestData()

	metric := metric_postgres.NewPostgresMetricWithUser(user)
	metric.Set(key, 3)

	metric.Sub(key, 1.5)

	if value, err := checkMetric(user.Id, key); err != nil {
		t.Error(err)
	} else {
		assert.Equal(t, 1.5, value)
	}

	metric.Sub(key, 0.25)

	if value, err := checkMetric(user.Id, key); err != nil {
		t.Error(err)
	} else {
		assert.Equal(t, 1.25, value)
	}
}

func TestSubNoUser(t *testing.T) {

}
