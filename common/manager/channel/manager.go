package channel

import (
	"github.com/pkg/errors"
	"github.com/uber-go/zap"
	"github.com/yezooz/epicglue/common/helpers"
	"github.com/yezooz/epicglue/common/manager"
	"github.com/yezooz/epicglue/common/model"
	r "gopkg.in/dancannon/gorethink.v2"
)

var (
	channelTableName = "channel"
	log              = zap.New(zap.NewJSONEncoder(zap.NoTime()))
)

type Manager struct {
	session r.QueryExecutor
	user    *model.User
}

func NewChannelManager(user *model.User) (manager.Channel, error) {
	if user == nil {
		return nil, errors.New("User is required")
	}

	return &Manager{
		session: session,
		user:    user,
	}, nil
}

func (m Manager) Get(channelID int64) (*model.Channel, error) {
	res, err := r.Table(channelTableName).Get(channelID).Run(m.session)

	if err != nil {
		log.Error(err.Error())
		return nil, err
	}

	channel := model.Channel{}
	err = res.One(&channel)

	if err != nil {
		switch err {
		case r.ErrEmptyResult:
			return nil, nil
		default:
			log.Error(err.Error())
			return nil, err
		}
	}

	if channel.User != nil && channel.User.ID != m.user.ID {
		log.Error(helpers.ERR_WRONG_CHANNEL_OWNER, zap.Int64("owner", channel.User.ID), zap.Int64("user", m.user.ID))
		return nil, errors.New(helpers.ERR_WRONG_CHANNEL_OWNER)
	}

	return &channel, nil
}

func (m Manager) All() ([]model.Channel, error) {
	res, err := r.Table(channelTableName).Filter(r.Or(
		map[string]interface{}{
			"user_id": nil,
		},
		map[string]interface{}{
			"user_id": m.user.ID,
		},
	)).Run(m.session)

	if err != nil {
		log.Error(err.Error())
		return nil, err
	}

	channels := []model.Channel{}
	err = res.All(&channels)

	if err != nil {
		switch err {
		case r.ErrEmptyResult:
			return channels, nil
		default:
			log.Error(err.Error())
			return nil, err
		}
	}

	return channels, nil
}

func (m Manager) Create(channel model.Channel) (*model.Channel, error) {
	panic("Not implemented")
}

func (m Manager) Update(channel model.Channel) (*model.Channel, error) {
	panic("Not implemented")
}

func (m Manager) Delete(channelID int64) error {
	panic("Not implemented")
}
