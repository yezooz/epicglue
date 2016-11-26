// +build integration

package metric_postgres_test

import (
	"errors"
	"github.com/stretchr/testify/assert"
	"gitlab.com/epicglue/api/connection/database/postgres"
	"gitlab.com/epicglue/api/helpers"
	"gitlab.com/epicglue/api/metric/postgres"
	"gitlab.com/epicglue/api/model"
	"testing"
)

func checkMetric(user_id int64, key string) (float64, error) {
	db := postgres.NewPostgres()

	query := `SELECT value FROM user_metric WHERE user_id = $1 AND key = $2`

	var value float64
	if err := db.QueryRow(query, user_id, key).Scan(&value); err != nil {
		return 0, err
	}

	return value, nil
}

func makeTestData() (*model.User, string) {
	user := test_helper.MakeTestUser()
	user.Id = 1

	return &user, helpers.RandomString(16)
}

func TestTooLongKey(t *testing.T) {
	user, _ := makeTestData()
	key := helpers.RandomString(101)

	metric := metric_postgres.NewPostgresMetricWithUser(user)
	metric.Set(key, 1)

	if _, err := checkMetric(user.Id, key); err != nil {
		assert.Equal(t, errors.New("sql: no rows in result set").Error(), err.Error())
	}
}

func TestDecimalPoints(t *testing.T) {

}

func TestInc(t *testing.T) {
	user, key := makeTestData()

	metric := metric_postgres.NewPostgresMetricWithUser(user)
	metric.Inc(key)

	if value, err := checkMetric(user.Id, key); err != nil {
		t.Error(err)
	} else {
		assert.Equal(t, 1.0, value)
	}

	metric.Inc(key)

	if value, err := checkMetric(user.Id, key); err != nil {
		t.Error(err)
	} else {
		assert.Equal(t, 2.0, value)
	}
}

func TestIncNoUser(t *testing.T) {

}

func TestSet(t *testing.T) {
	user, key := makeTestData()

	metric := metric_postgres.NewPostgresMetricWithUser(user)
	metric.Set(key, 3.33)

	if value, err := checkMetric(user.Id, key); err != nil {
		t.Error(err)
	} else {
		assert.Equal(t, 3.33, value)
	}

	metric.Set(key, 5.0)

	if value, err := checkMetric(user.Id, key); err != nil {
		t.Error(err)
	} else {
		assert.Equal(t, 5.0, value)
	}
}

func TestSetNoUser(t *testing.T) {

}

func TestAdd(t *testing.T) {
	user, key := makeTestData()

	metric := metric_postgres.NewPostgresMetricWithUser(user)
	metric.Add(key, 1)

	if value, err := checkMetric(user.Id, key); err != nil {
		t.Error(err)
	} else {
		assert.Equal(t, 1.0, value)
	}

	metric.Add(key, 5.66)

	if value, err := checkMetric(user.Id, key); err != nil {
		t.Error(err)
	} else {
		assert.Equal(t, 6.66, value)
	}
}

func TestAddNoUser(t *testing.T) {

}
