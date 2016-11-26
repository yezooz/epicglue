package pipe

import (
	"errors"
	"gitlab.com/epicglue/epicglue/app/manager"
	"gitlab.com/epicglue/epicglue/app/model"
	r "gopkg.in/dancannon/gorethink.v2"
)

type Manager struct {
	session *r.Session
	user    *model.User
}

func NewPipeManager(session *r.Session, user *model.User) (manager.Pipe, error) {
	if session == nil {
		return nil, errors.New("Active session is required")
	}

	if user == nil {
		return nil, errors.New("User is required")
	}

	return &Manager{
		session: session,
		user:    user,
	}, nil
}
