package test_helper

func HasIndex(indexName string) bool {
	es := connection.NewConnector().GetES()

	has, err := es.IndicesExists(indexName)

	return has == true && err == nil
}
