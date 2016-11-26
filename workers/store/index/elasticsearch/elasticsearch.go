package store_index_elasticsearch

import (
	"gitlab.com/epicglue/epicglue/app/connection/index"
	"gitlab.com/epicglue/epicglue/app/connection/index/elasticsearch"
	"gitlab.com/epicglue/epicglue/app/helpers"
)

var log = helpers.GetLogger("process_store")

type ElasticsearchStore struct {
	Connection index.Index
}

func NewElasticsearchIndexStore() *ElasticsearchStore {
	return &ElasticsearchStore{
		Connection: elasticsearch.NewElasticsearch(),
	}
}
