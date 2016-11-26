package filters

import (
	"fmt"
	"github.com/stretchr/testify/assert"
	"reflect"
	"testing"
)

func TestRegexp(t *testing.T) {
	for _, in := range []string{
		"https://foo.com/blah_blah",
		"http://foo.com/blah_blah",
		"http://foo.com/blah_blah/",
		"http://foo.com/blah_blah_(wikipedia)",
		"http://foo.com/blah_blah_(wikipedia)_(again)",
		"http://www.example.com/wpstyle/?p=364",
		"https://www.example.com/foo/?bar=baz&inga=42&quux",
		"http://✪df.ws/123",
		"http://userid:password@example.com:8080",
		"http://userid:password@example.com:8080/",
		"http://userid@example.com",
		"http://userid@example.com/",
		"http://userid@example.com:8080",
		"http://userid@example.com:8080/",
		"http://userid:password@example.com",
		"http://userid:password@example.com/",
		"http://142.42.1.1/",
		"http://142.42.1.1:8080/",
		"http://➡.ws/䨹",
		"http://⌘.ws",
		"http://⌘.ws/",
		"http://foo.com/blah_(wikipedia)#cite-1",
		"http://foo.com/blah_(wikipedia)_blah#cite-1",
		"http://foo.com/unicode_(✪)_in_parens",
		"http://foo.com/(something)?after=parens",
		"http://☺.damowmow.com/",
		"http://code.google.com/events/#&product=browser",
		"http://j.mp",
		"http://foo.bar/?q=Test%20URL-encoded%20stuff",
		"http://مثال.إختبار",
		"http://例子.测试",
		"http://उदाहरण.परीक्षा",
		"http://-.~_!$&'()*+,;=:%40:80%2f::::::@example.com",
		"http://1337.net",
		"http://a.b-c.de",
		"http://223.255.255.254",
	} {
		assert.True(t, FULL_LINK.MatchString(in), fmt.Sprintf("%q should be valid", in))
	}

	for _, in := range []string{
		"http://",
		"http://.",
		"http://..",
		"http://../",
		"http://?",
		"http://??",
		"http://??/",
		"http://#",
		"http://##",
		"http://##/",
		"//",
		"//a",
		"///a",
		"///",
		"http:///a",
		"foo.com",
		"rdar://1234",
		"h://test",
		"http:// shouldfail.com",
		":// should fail",
		"ftps://foo.bar/",
		"http://-error-.invalid/",
		"http://a.b--c.de/",
		"http://-a.b.co",
		"http://a.b-.co",
		"http://123.123.123",
		"http://3628126748",
		"http://.www.foo.bar/",
		//"http://www.foo.bar./",
		"http://.www.foo.bar./",
	} {
		assert.False(t, FULL_LINK.MatchString(in), fmt.Sprintf("%q should not be valid", in))
	}
}

func TestFindLinksWithProtocol(t *testing.T) {
	var tests = []struct {
		in  string
		out []string
	}{
		{"test string", []string{}},
		{"test string with https://www.epicglue.com and more", []string{"https://www.epicglue.com"}},
		{"https://www.epicglue.com https://www.epicglue.io", []string{"https://www.epicglue.com", "https://www.epicglue.io"}},
		{"https://epicglue.cz", []string{"https://epicglue.cz"}},
		{"is it http://epicglue.travel ?", []string{"http://epicglue.travel"}},
		{"|| http://epicglue.com/test case", []string{"http://epicglue.com/test"}},
	}

	for _, tt := range tests {
		out := findLinks(tt.in)

		if len(out) == 0 && len(tt.out) == 0 {
			continue
		}

		if !reflect.DeepEqual(out, tt.out) {
			t.Errorf("findLinks(%q) => %q, want %q", tt.in, out, tt.out)
		}
	}
}

func TestFindLinksWithoutProtocol(t *testing.T) {
	var tests = []struct {
		in  string
		out []string
	}{
		{"test string", []string{}},
		{"test string with www.epicglue.com and more", []string{"www.epicglue.com"}},
		{"www.epicglue.com www.epicglue.io", []string{"www.epicglue.com", "www.epicglue.io"}},
		{"epicglue.pl", []string{"epicglue.pl"}},
		{"is it epicglue.pl ?", []string{"epicglue.pl"}},
		{"|| epicglue.com/test case", []string{"epicglue.com/test"}},
	}

	for _, tt := range tests {
		out := findLinks(tt.in)

		if len(out) == 0 && len(tt.out) == 0 {
			continue
		}

		if !reflect.DeepEqual(out, tt.out) {
			t.Errorf("findLinks(%q) => %q, want %q", tt.in, out, tt.out)
		}
	}
}
