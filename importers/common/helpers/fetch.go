package helpers

import (
	"io/ioutil"
	"net/http"
)

func DoAndReadResponse(client *http.Client, request *http.Request) ([]byte, error) {
	resp, err := client.Do(request)
	if err != nil {
		return nil, err
	}

	defer resp.Body.Close()
	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return nil, err
	}

	return body, nil
}
