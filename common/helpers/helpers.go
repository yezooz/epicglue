package helpers

import (
	"crypto/sha1"
	"errors"
	"fmt"
	"github.com/araddon/gou"
	"math/rand"
	"regexp"
	"strings"
	"time"
	"unicode"
)

var (
	// unquoted array values must not contain: (" , \ { } whitespace NULL)
	// and must be at least one char
	unquotedChar  = `[^",\\{}\s(NULL)]`
	unquotedValue = fmt.Sprintf("(%s)+", unquotedChar)

	// quoted array values are surrounded by double quotes, can be any
	// character except " or \, which must be backslash escaped:
	quotedChar  = `[^"\\]|\\"|\\\\`
	quotedValue = fmt.Sprintf("\"(%s)*\"", quotedChar)

	// an array value may be either quoted or unquoted:
	arrayValue = fmt.Sprintf("(?P<value>(%s|%s))", unquotedValue, quotedValue)

	// Array values are separated with a comma IF there is more than one value:
	arrayExp = regexp.MustCompile(fmt.Sprintf("((%s)(,)?)", arrayValue))

	valueIndex int
)

type StringSlice []string

// Implements sql.Scanner for the String slice type
// Scanners take the database value (in this case as a byte slice)
// and sets the value of the type.  Here we cast to a string and
// do a regexp based parse
func (s *StringSlice) Scan(src interface{}) error {
	asBytes, ok := src.([]byte)
	if !ok {
		return error(errors.New("Scan source was not []bytes"))
	}

	asString := string(asBytes)
	parsed := parseArray(asString)
	(*s) = StringSlice(parsed)

	return nil
}

func parseArray(array string) []string {
	results := []string{}
	matches := arrayExp.FindAllStringSubmatch(array, -1)
	for _, match := range matches {
		s := match[valueIndex]
		// the string _might_ be wrapped in quotes, so trim them:
		s = strings.Trim(s, "\"")
		results = append(results, s)
	}
	return results
}

func RandomNumber(n int) int64 {
	letters := []rune("123456789")

	rand.Seed(time.Now().UnixNano())

	b := make([]rune, n)
	for i := range b {
		b[i] = letters[rand.Intn(len(letters))]
	}
	return StringToInt64(string(b))
}

func RandomString(n int) string {
	letters := []rune("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")

	rand.Seed(time.Now().UnixNano())

	b := make([]rune, n)
	for i := range b {
		b[i] = letters[rand.Intn(len(letters))]
	}
	return string(b)
}

func RandomEmail() string {
	return fmt.Sprintf("%s@epicglue.com", RandomString(16))
}

func StringToInt64(in string) int64 {
	out, _ := gou.CoerceInt64(in)

	return out
}

func StringToFloat64(in string) float64 {
	out, _ := gou.CoerceFloat(in)

	return out
}

func ConvertStringListToInterfaceList(list []string) []interface{} {
	new := make([]interface{}, len(list))
	for i, v := range list {
		new[i] = v
	}

	return new
}

func FlattenArrayOfStrings(arr []string) string {
	newArr := make([]string, 0)
	for _, el := range arr {
		newArr = append(newArr, fmt.Sprintf(`"%s"`, el))
	}

	return fmt.Sprintf("[%s]", strings.Join(newArr, ","))
}

func FlattenArrayOfInts(arr []int64) string {
	newArr := make([]string, 0)
	for _, el := range arr {
		newArr = append(newArr, fmt.Sprintf("%d", el))
	}

	return fmt.Sprintf("[%s]", strings.Join(newArr, ","))
}

func NextFullHour(t time.Time) time.Time {
	t2 := t.Add(1 * time.Hour)

	return time.Date(t2.Year(), t2.Month(), t2.Day(), t2.Hour(), 0, 0, 0, t.Location())
}

func CapitalizeFirstLetter(input string) string {
	a := []rune(input)
	a[0] = unicode.ToUpper(a[0])
	return string(a)
}

func IsPasswordValid(enteredPassword string, originalPassword string, salt string) bool {
	hash := sha1.New()
	hash.Write([]byte(fmt.Sprintf("%s.%s", enteredPassword, salt)))

	return fmt.Sprintf("%x", hash.Sum(nil)) == originalPassword
}

func ToStringArray(values []int64) []string {
	newValues := make([]string, len(values))
	for i, v := range values {
		newValues[i] = fmt.Sprintf("%d", v)
	}

	return newValues
}
