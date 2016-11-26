package test_helper

import "gitlab.com/epicglue/epicglue/app/connection"

func HasIndex(indexName string) bool {
	es := connection.NewConnector().GetES()

	has, err := es.IndicesExists(indexName)

	return has == true && err == nil
}
