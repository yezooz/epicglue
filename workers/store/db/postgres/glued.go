package store_db_postgres

import (
	"fmt"
	"github.com/Sirupsen/logrus"
	"runtime/debug"
	"strings"
	"time"
)

// TODO: use item/store implementation
func (db PostgresStore) MarkAsGlued(task *worker_model.Task) error {
	start := time.Now()

	itemIds := []string{task.ItemId}

	query := fmt.Sprintf(`
			UPDATE
				user_item
			SET
				is_glued = TRUE
			WHERE
			    user_id = %d AND
				item_id IN ('%s')`, task.UserId, strings.Join(itemIds, `','`))

	_, err := db.Connection.DB().Exec(query)

	if err != nil {
		log.WithFields(logrus.Fields{
			"stack":    string(debug.Stack()),
			"took":     time.Since(start),
			"took_str": time.Since(start).String(),
			"query":    query,
		}).Error(err)

		return err
	}

	return nil
}

// TODO: use item/store implementation
func (db PostgresStore) MarkAsUnglued(task *worker_model.Task) error {
	start := time.Now()

	itemIds := []string{task.ItemId}

	query := fmt.Sprintf(`
			UPDATE
				user_item
			SET
				is_glued = FALSE
			WHERE
			    user_id = %d
				item_id IN ('%s')`, task.UserId, strings.Join(itemIds, `','`))

	_, err := db.Connection.DB().Exec(query)

	if err != nil {
		log.WithFields(logrus.Fields{
			"stack":    string(debug.Stack()),
			"took":     time.Since(start),
			"took_str": time.Since(start).String(),
			"query":    query,
		}).Error(err)

		return err
	}

	return nil
}
