package store_index_elasticsearch

import (
	"github.com/yezooz/epicglue/app/connection/index"
	"github.com/yezooz/epicglue/app/connection/index/elasticsearch"
	"github.com/yezooz/epicglue/app/helpers"
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
