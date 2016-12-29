package test_helper

import (
	"bytes"
	"encoding/json"
	"fmt"
	"github.com/yezooz/epicglue/common/config"
	"github.com/yezooz/epicglue/common/model"
	"io/ioutil"
	"net/http"
	"net/url"
	"strconv"
)

const (
	GET    = "GET"
	POST   = "POST"
	PUT    = "PUT"
	DELETE = "DELETE"
)

func MakeGetRequest(path string, data map[string]string) *http.Request {
	return makeURLRequestOfType(GET, path, data)
}

func MakeGetRequestWithUserId(path string, data map[string]string, userId int64) *http.Request {
	return makeURLRequestOfTypeForUser(GET, path, data, userId)
}

func MakePostRequest(path string, data interface{}) *http.Request {
	return makeURLRequestOfTypeWithPayload(POST, path, data)
}

func MakePostRequestWithUserId(path string, data interface{}, userId int64) *http.Request {
	return makeURLRequestOfTypeWithPayloadForUser(POST, path, data, userId)
}

func MakePutRequest(path string, data interface{}) *http.Request {
	return makeURLRequestOfTypeWithPayload(PUT, path, data)
}

func MakePutRequestWithUserId(path string, data interface{}, userId int64) *http.Request {
	return makeURLRequestOfTypeWithPayloadForUser(PUT, path, data, userId)
}

func MakeDeleteRequest(path string, data interface{}) *http.Request {
	return makeURLRequestOfTypeWithPayload(DELETE, path, data)
}

func MakeDeleteRequestWithUserId(path string, data interface{}, userId int64) *http.Request {
	return makeURLRequestOfTypeWithPayloadForUser(DELETE, path, data, userId)
}

func makeURLRequestOfType(requestType string, path string, data map[string]string) *http.Request {
	u := currentURLFromConfig()
	u.Path = path
	if data != nil {
		u.Fragment = mapToURLValues(data).Encode()
	}

	r, _ := http.NewRequest(requestType, fmt.Sprintf("%v", u), nil)
	r.Header.Add("Content-Type", "application/json")

	return r
}

func makeURLRequestOfTypeWithPayload(requestType string, path string, jsonData interface{}) *http.Request {
	var data []byte
	if jsonData != nil {
		data, _ = json.Marshal(&jsonData)
	}

	u := currentURLFromConfig()
	u.Path = path

	r, _ := http.NewRequest(requestType, fmt.Sprintf("%v", u), bytes.NewBuffer(data))
	r.Header.Add("Content-Type", "application/json")
	r.Header.Add("Content-Length", strconv.Itoa(len(data)))

	return r
}

func mapToURLValues(data map[string]string) url.Values {
	urlData := url.Values{}

	for k, v := range data {
		urlData.Add(k, v)
	}

	return urlData
}

func makeURLRequestOfTypeForUser(requestType string, path string, data map[string]string, userId int64) *http.Request {
	user := &model.User{
		Id: userId,
	}

	user_manager.NewDefaultUserManagerWithUser(user).GenerateAndStoreToken()

	r := makeURLRequestOfType(requestType, path, data)
	//r.Header.Add("Token", user.Token)

	return r
}

func makeURLRequestOfTypeWithPayloadForUser(requestType string, path string, jsonData interface{}, userId int64) *http.Request {
	user := &model.User{
		ID: userId,
	}

	user_manager.NewDefaultUserManagerWithUser(user).GenerateAndStoreToken()

	r := makeURLRequestOfTypeWithPayload(requestType, path, jsonData)
	//r.Header.Add("Token", user.Token)

	return r
}

func currentURLFromConfig() *url.URL {
	config := config.LoadConfig()

	u, err := url.ParseRequestURI(fmt.Sprintf("http://localhost:%d", config.App.Port))

	if err != nil {
		panic("Invalid URL from config")
	}

	return u
}

func ReadResponse(httpResponse *http.Response) interface{} {
	resBody, _ := ioutil.ReadAll(httpResponse.Body)

	var response interface{}
	json.Unmarshal(resBody, &response)

	return response
}
