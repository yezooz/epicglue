package worker_model

import (
	"encoding/json"
	"fmt"
	"github.com/Sirupsen/logrus"
	"github.com/yezooz/epicglue/app/connection/database/postgres"
	"github.com/yezooz/epicglue/app/helpers"
	"github.com/yezooz/epicglue/app/model"
	"runtime/debug"
	"strconv"
	"strings"
)

var log = helpers.GetLogger("worker")

const (
	TaskTypeIndex = iota
	TaskTypeUpdate
	TaskTypeDelete
	TaskTypeUndelete
	TaskTypeGlue
	TaskTypeUnglue
	TaskTypeRead
	TaskTypeUnread
)

type Task struct {
	TaskType int
	ItemId   string
	UserId   int64

	// For indexing
	TTL            int64
	SubscriptionId int64
	UserSubItemId  int64
	ForceReload    bool
}

func NewTaskFromString(taskString string) *Task {
	task := strings.Split(taskString, "|")

	var (
		user           *model.User
		userId         int64
		itemId         string = task[2]
		taskType       int
		TTL            int64
		subscriptionId int64
		userSubItemId  int64
	)

	userId, err := strconv.ParseInt(task[0], 10, 64)
	if err != nil {
		panic(err.Error())
	}

	taskType, err = strconv.Atoi(task[1])
	if err != nil {
		panic(err.Error())
	}

	user = &model.User{
		Id: userId,
	}

	if taskType == TaskTypeIndex {
		TTL, err = strconv.ParseInt(task[3], 10, 64)
		if err != nil {
			panic(err.Error())
		}

		subscriptionId, err = strconv.ParseInt(task[4], 10, 64)
		if err != nil {
			panic(err.Error())
		}

		userSubItemId, err = strconv.ParseInt(task[5], 10, 64)
		if err != nil {
			panic(err.Error())
		}

		return NewIndexTask(itemId, user, TTL, subscriptionId, userSubItemId)
	}

	return NewUpdateTask(taskType, itemId, user)
}

func NewIndexTask(itemId string, user *model.User, TTL int64, subscriptionId int64, userSubItemId int64) *Task {
	return &Task{
		TaskType:       TaskTypeIndex,
		ItemId:         itemId,
		UserId:         user.Id,
		TTL:            TTL,
		SubscriptionId: subscriptionId,
		UserSubItemId:  userSubItemId,
	}
}

func NewUpdateTask(taskType int, itemId string, user *model.User) *Task {
	switch taskType {
	case TaskTypeUpdate:
	case TaskTypeDelete:
	case TaskTypeUndelete:
	case TaskTypeGlue:
	case TaskTypeUnglue:
	case TaskTypeRead:
	case TaskTypeUnread:
		break
	default:
		panic(fmt.Sprintf("Task type %d not recognized: ", taskType))
	}

	return &Task{
		TaskType: taskType,
		ItemId:   itemId,
		UserId:   user.Id,
	}
}

func (t *Task) IndexName() string {
	return fmt.Sprintf("user_%d", t.UserId)
}

func (t *Task) GetItem() *model.Item {
	item := &model.Item{}

	log.Info(t.ItemId)
	postgres.NewPostgres().First(item, "id  = ?", t.ItemId)

	return item
}

func (t *Task) String() string {
	if t.TaskType == TaskTypeIndex {
		return fmt.Sprintf("%d|%d|%s|%d|%d|%d", t.UserId, t.TaskType, t.ItemId, t.TTL, t.SubscriptionId, t.UserSubItemId)
	}

	return fmt.Sprintf("%d|%d|%s", t.UserId, t.TaskType, t.ItemId)
}

func (t *Task) InsertJSON() []byte {
	j, err := json.Marshal(t.GetItem().ToElasticItem())

	if err != nil {
		log.WithFields(logrus.Fields{
			"stack": string(debug.Stack()),
		}).Error(err)

		return nil
	}

	return j
}

func (t *Task) UpdateJSON() []byte {
	item := t.GetItem()

	updateItem := updateItem{
		Points:    item.Points.Int64,
		Comments:  item.Comments.Int64,
		UpdatedAt: item.UpdatedAt,
	}

	j, err := json.Marshal(&updateItem)

	if err != nil {
		log.WithFields(logrus.Fields{
			"stack": string(debug.Stack()),
		}).Error(err)

		return nil
	}

	return j
}
