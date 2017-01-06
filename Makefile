.PHONY: build

PACKAGES = $(shell go list ./... | grep -v /vendor/)

ifneq ($(shell uname), Darwin)
	EXTLDFLAGS = -extldflags "-static" $(null)
else
	EXTLDFLAGS =
endif

all: gen build_static

deps: deps_backend deps_frontend

deps_frontend:
	go get -u github.com/drone/drone-ui/dist

deps_backend:
	go get -u golang.org/x/tools/cmd/cover
	go get -u github.com/jteeuwen/go-bindata/...
	go get -u github.com/elazarl/go-bindata-assetfs/...
	go get -u github.com/drone/mq/...
	go get -u github.com/tidwall/redlog

gen: gen_template gen_migrations

gen_template:
	go generate github.com/yezooz/epicglue/api/server/template

gen_migrations:
	go generate github.com/yezooz/epicglue/api/store/datastore/ddl

test:
	go test -cover $(PACKAGES)

# docker run --publish=3306:3306 -e MYSQL_DATABASE=test -e MYSQL_ALLOW_EMPTY_PASSWORD=yes  mysql:5.6.27
test_mysql:
	DATABASE_DRIVER="mysql" DATABASE_CONFIG="root@tcp(127.0.0.1:3306)/test?parseTime=true" go test github.com/drone/drone/store/datastore

# docker run --publish=5432:5432 postgres:9.4.5
test_postgres:
	DATABASE_DRIVER="postgres" DATABASE_CONFIG="host=127.0.0.1 user=postgres dbname=postgres sslmode=disable" go test github.com/drone/drone/store/datastore
