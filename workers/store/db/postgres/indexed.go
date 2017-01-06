package store_db_postgres

import (
	"fmt"
	"github.com/Sirupsen/logrus"
	"github.com/yezooz/epicglue/app/helpers"
	"github.com/yezooz/epicglue/workers/model"
	"runtime/debug"
	"strings"
	"time"
)

func (db PostgresStore) MarkAsIndexed(task *worker_model.Task) error {
	start := time.Now()

	itemIds := []int64{task.UserSubItemId}

	query := fmt.Sprintf(`
			UPDATE
				user_item_subscription
			SET
				is_indexed = TRUE
			WHERE
				id IN (%s)`, strings.Join(helpers.ToStringArray(itemIds), `,`))

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
