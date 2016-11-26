package config

import (
	"encoding/json"
	"fmt"
	"log"
	"os"
	"strings"
	"sync"
)

const (
	LOG_FORMAT_TEXT = "text"
	LOG_FORMAT_JSON = "json"
)

type Config struct {
	App struct {
		Secret      string `json:"secret"`
		Port        int64  `json:"port"`
		AppleURL    string `json:"apple_url"`
		AppleSecret string `json:"apple_secret"`
		TaskLimit   int64  `json:"task_limit"`
		WorkerLimit int64  `json:"worker_limit"`
		IndexLimit  int64  `json:"index_limit"`
		IsTest      bool   `json:"is_test"`
		LogFormat   string `json:"log_format,omitempty"`
		LogLevel    string `json:"log_level,omitempty"`
	} `json:"app"`
	Db struct {
		Hosts          []string `json:"hosts"`
		Name           string   `json:"name"`
		User           string   `json:"user"`
		Pass           string   `json:"pass"`
		MaxConnections int      `json:"max_connections"`
	} `json:"db"`
	API struct {
		RequestLimit          int64 `json:"request_limit"`
		RequestLimitKeyExpiry int64 `json:"request_limit_key_expiry"`
		CountLimit            int64 `json:"count_limit"`
	} `json:"api"`
}

var (
	configuration Config
	configName    string
	once          sync.Once
)

func LoadConfig() *Config {
	once.Do(func() {
		if os.Getenv("ENV") != "" {
			configName = os.Getenv("ENV")
		} else {
			configName = "dev"
		}

		gopaths := strings.Split(os.Getenv("GOPATH"), ":")

		configPath := fmt.Sprintf("%s/config/%s.json", gopaths[0], configName)

		file, err := os.Open(configPath)

		if err != nil {
			log.Panicf("Config not found in %s", configPath)
		}

		decoder := json.NewDecoder(file)
		configuration = Config{}

		if err := decoder.Decode(&configuration); err != nil {
			fmt.Println("error:", err)
		}
	})

	return &configuration
}
