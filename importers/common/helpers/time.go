package helpers

import (
	"github.com/spf13/cast"
	"strconv"
	"time"
)

func TimeFromTimestamp(timestamp int64) time.Time {
	return time.Unix(timestamp/1000, 0)
}

func TimeFromTimestampString(timestampString string) time.Time {
	timestamp, err := strconv.ParseInt(timestampString, 10, 64)
	if err != nil {
		panic(err)
	}

	return TimeFromTimestamp(timestamp)
}

type UnixTime struct {
	time.Time
}

func (uxt *UnixTime) parseInput(input []byte) int64 {
	var timestamp int64 = 0

	timestamp = cast.ToInt64(string(input))
	if timestamp > 0 {
		return timestamp
	}

	timestamp = int64(cast.ToFloat64(string(input)))
	if timestamp > 0 {
		return timestamp
	}

	return timestamp
}

func (uxt *UnixTime) UnmarshalJSON(b []byte) (err error) {
	if b[0] == '"' && b[len(b)-1] == '"' {
		b = b[1 : len(b)-1]
	}

	uxt.Time = time.Unix(uxt.parseInput(b), 0)

	return nil
}

func (uxt *UnixTime) MarshalJSON() ([]byte, error) {
	return []byte(uxt.Time.String()), nil
}
