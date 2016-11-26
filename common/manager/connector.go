package manager

import (
	"github.com/uber-go/zap"
	"github.com/yezooz/epicglue/common/config"
	r "gopkg.in/dancannon/gorethink.v2"
	"sync"
)

var (
	log           = zap.New(zap.NewJSONEncoder(zap.NoTime()))
	c             *Connector
	dbProvisioned bool
	once          sync.Once
)

type Connector struct {
	db   *r.Session
	conf *config.Config
}

func NewConnector() *Connector {
	once.Do(func() {
		c = &Connector{
			conf: config.LoadConfig(),
		}
	})

	return c
}

func (c *Connector) GetDB() *r.Session {
	if c.db == nil {
		var err error

		c.db, err = r.Connect(r.ConnectOpts{
			Addresses:  c.conf.Db.Hosts,
			InitialCap: c.conf.Db.MaxConnections,
			MaxOpen:    c.conf.Db.MaxConnections,
			Database:   c.conf.Db.Name,
			//Username: c.conf.Db.User,
			//Password: c.conf.Db.Pass,
		})

		if err != nil {
			log.Fatal(err.Error())
		}

		if !dbProvisioned {
			c.ProvisionDB()
		}
	}

	return c.db
}

func (c *Connector) ProvisionDB() error {
	// DO SOME INITIAL STUFF

	dbProvisioned = true

	return nil
}
