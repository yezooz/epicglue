package helpers

import (
	"net/http"
	"strconv"
)

func UserIdFromHttpHeader(header http.Header) int64 {
	userIdAsString := header.Get("UserId")

	userIdAsInt64, err := strconv.ParseInt(userIdAsString, 10, 64)

	if err != nil {
		GetLogger("helpers").Panicf("Failed to convert %v to int64", userIdAsString)
	}

	return userIdAsInt64
}
