package helpers

import (
	"encoding/json"
	"io"
	"io/ioutil"
)

func HttpPayloadToObject(payload io.ReadCloser, destinationObject interface{}) interface{} {
	if bytes := httpPayloadToBytes(payload); bytes != nil {
		return transformIntoObject(bytes, destinationObject)
	}

	return nil
}

func httpPayloadToBytes(payload io.ReadCloser) []byte {
	data, err := ioutil.ReadAll(payload)
	if err != nil {
		return nil
	}

	return data
}

func transformIntoObject(bytes []byte, destinationObject interface{}) interface{} {
	if err := json.Unmarshal(bytes, &destinationObject); err != nil {
		return nil
	}

	return destinationObject
}
