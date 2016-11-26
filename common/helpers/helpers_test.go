package helpers_test

import (
	"github.com/stretchr/testify/assert"
	"gitlab.com/epicglue/epicglue/app/helpers"
	"gitlab.com/epicglue/epicglue/app/helpers/test"
	"io/ioutil"
	"strings"
	"testing"
)

func TestScan(t *testing.T) {

}

//func TestRandomNumber(t *testing.T) {
//	r1 := helpers.RandomNumber(8)
//	assert.Len(t, r1, 8)
//
//	r2 := helpers.RandomNumber(8)
//	assert.Len(t, r2, 8)
//
//	r3 := helpers.RandomNumber(1)
//	assert.Len(t, r3, 1)
//
//	r4 := helpers.RandomNumber(16)
//	assert.Len(t, r4, 16)
//
//	assert.NotEqual(t, r1, r2)
//}

func TestRandomString(t *testing.T) {
	r1 := helpers.RandomString(8)
	assert.Len(t, r1, 8)

	r2 := helpers.RandomString(8)
	assert.Len(t, r2, 8)

	r3 := helpers.RandomString(1)
	assert.Len(t, r3, 1)

	r4 := helpers.RandomString(16)
	assert.Len(t, r4, 16)

	assert.NotEqual(t, r1, r2)
}

func TestRandomEmail(t *testing.T) {
	e1 := helpers.RandomEmail()
	assert.Len(t, e1, 29)

	e2 := helpers.RandomEmail()
	assert.Len(t, e2, 29)

	assert.NotEqual(t, e1, e2)

	assert.True(t, strings.HasSuffix(e1, "@epicglue.com"))
	assert.True(t, strings.HasSuffix(e2, "@epicglue.com"))
}

func TestFlattenArrayOfStrings(t *testing.T) {
	assert.Equal(t, "[]", helpers.FlattenArrayOfStrings([]string{}))
	assert.Equal(t, `["1"]`, helpers.FlattenArrayOfStrings([]string{"1"}))
	assert.Equal(t, `["1","2"]`, helpers.FlattenArrayOfStrings([]string{"1", "2"}))
}

func TestFlattenArrayOfInts(t *testing.T) {
	assert.Equal(t, "[]", helpers.FlattenArrayOfInts([]int64{}))
	assert.Equal(t, `[1]`, helpers.FlattenArrayOfInts([]int64{1}))
	assert.Equal(t, `[1,2]`, helpers.FlattenArrayOfInts([]int64{1, 2}))
}

func TestStringToInt64(t *testing.T) {
	assert.Equal(t, helpers.StringToInt64("-9223372036854775808"), int64(-9223372036854775808))
	assert.Equal(t, helpers.StringToInt64("9223372036854775807"), int64(9223372036854775807))
}

func TestStringToFloat64(t *testing.T) {
	assert.Equal(t, helpers.StringToFloat64("4.11"), float64(4.11))
}

func TestConvertStringListToInterfaceList(t *testing.T) {
	strList := []string{"A", "B", "C"}

	convertedStrList := helpers.ConvertStringListToInterfaceList(strList)

	for i, _ := range convertedStrList {
		assert.Equal(t, strList[i], convertedStrList[i].(string))
	}
}

//func TestNextFullHour(t *testing.T) {
//	t1 := time.Date(2016, time.September, 12, 16, 10, 10, 0, time.UTC)
//	nt1 := helpers.NextFullHour(t1)
//	assert.Equal(t, time.Date(2016, time.September, 12, 17, 0, 0, 0, time.UTC), nt1)
//
//	t2 := time.Date(2016, time.September, 10, 23, 8, 10, 0, time.UTC)
//	nt2 := helpers.NextFullHour(t2)
//	assert.Equal(t, time.Date(2016, time.September, 13, 0, 0, 0, 0, time.UTC), nt2)
//
//	t3 := time.Date(2016, time.September, 12, 10, 0, 0, 0, time.UTC)
//	nt3 := helpers.NextFullHour(t3)
//	assert.Equal(t, t3, nt3)
//}

func TestCapitalizeFirstLetter(t *testing.T) {
	str1 := "epicglue"
	assert.Equal(t, "Epicglue", helpers.CapitalizeFirstLetter(str1))

	str2 := "EPICGLUE"
	assert.Equal(t, "EPICGLUE", helpers.CapitalizeFirstLetter(str2))
}

func TestToStringArray(t *testing.T) {
	arr1 := []int64{1, 2, 3}
	assert.Equal(t, []string{"1", "2", "3"}, helpers.ToStringArray(arr1))
}

func TestMakeGetRequest(t *testing.T) {

}

func TestMakePostRequest(t *testing.T) {
	r := test_helper.MakePostRequest("/", map[string]string{
		"testKey": "testValue",
	})

	assert.Equal(t, "application/json", r.Header.Get("Content-Type"))
	assert.Equal(t, "23", r.Header.Get("Content-Length"))
	assert.Equal(t, "localhost:7000", r.Host)
	assert.Equal(t, "/", r.URL.Path)
	assert.Equal(t, "POST", r.Method)

	data, _ := ioutil.ReadAll(r.Body)

	assert.Equal(t, `{"testKey":"testValue"}`, string(data))
}

func TestIsPasswordValid(t *testing.T) {
	assert.True(t, helpers.IsPasswordValid("dupadupa", "3482a5ec089593947b892c137cc7668f46b19ea1", "dupa"))
}
