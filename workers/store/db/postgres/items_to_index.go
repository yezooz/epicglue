package store_db_postgres

import (
	"database/sql"
	"github.com/Sirupsen/logrus"
	"gitlab.com/epicglue/epicglue/app/model"
	"gitlab.com/epicglue/epicglue/app/worker/model"
	"runtime/debug"
)

func (db PostgresStore) ItemsToIndex(processingChannel chan *worker_model.Task, limit uint64) {
	var offset uint64 = 0

	for {
		numberOfItemsToIndex := db.fetchAndProcessItemsToIndex(processingChannel, limit, offset)

		if numberOfItemsToIndex != limit {
			break
		}

		offset += limit
	}
}

func (db PostgresStore) fetchAndProcessItemsToIndex(processingChannel chan *worker_model.Task, limit uint64, skip uint64) uint64 {
	itemsToProcess := db.fetchItemsToIndex(limit, skip)

	if itemsToProcess == nil {
		return uint64(0)
	}

	return uint64(db.processItemsToIndex(itemsToProcess, processingChannel))
}

func (db PostgresStore) fetchItemsToIndex(limit uint64, skip uint64) *sql.Rows {
	query := `
		SELECT
			uis.user_subscription_id AS subscription_id,
			uis.id as user_item_subscription_id,
			ui.item_id,
			u.id AS user_id,
			u.username AS username
		FROM
			user_item AS ui
		JOIN
			user_item_subscription AS uis ON (uis.user_item_id = ui.id)
		JOIN
			auth_user AS u ON (u.id = ui.user_id)
		JOIN
			"user" as uu ON (uu.user_id = u.id)
		WHERE
			uis.is_indexed = FALSE AND
			ui.is_deleted = FALSE
		ORDER BY
			ui.created_at ASC
		LIMIT
			$1
		OFFSET
			$2`

	rows, err := db.Connection.DB().Query(query, limit, skip)

	if err != nil {
		log.WithFields(logrus.Fields{
			"stack": string(debug.Stack()),
		}).Error(err)

		return nil
	}

	return rows
}

func (db PostgresStore) processItemsToIndex(itemsToProcess *sql.Rows, processingChannel chan *worker_model.Task) uint64 {
	var (
		numberOfItemsToIndex int
		itemId               string
		userId               int64
		username             string
		subscriptionId       int64
		userItemSubId        int64
	)

	for itemsToProcess.Next() {
		err := itemsToProcess.Scan(
			&subscriptionId,
			&userItemSubId,
			&itemId,
			&userId,
			&username,
		)

		if err != nil {
			log.WithFields(logrus.Fields{
				"stack": string(debug.Stack()),
			}).Error(err)

			continue
		}

		// TODO: cache User and Plan
		user := model.User{
			Id: userId,
		}

		ttl := user.GetPlan().TTL
		if ttl > 0 {
			ttl = ttl / 86400
		}

		// TODO: push to Redis, and go from there; processingChannel <- task.String()
		processingChannel <- worker_model.NewIndexTask(
			itemId,
			&user,
			ttl,
			subscriptionId,
			userItemSubId,
		)

		numberOfItemsToIndex++
	}
	itemsToProcess.Close()

	return uint64(numberOfItemsToIndex)
}
