package server

import (
	"fmt"
	"github.com/satori/go.uuid"
)

func stringIdToUuid(id string) uuid.UUID {
	u, err := uuid.FromString(id)
	if err != nil {
		panic(fmt.Sprintf("String %s is not UUID", id))
	}

	return u
}
