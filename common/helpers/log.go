package helpers

import (
	"fmt"
	"github.com/Sirupsen/logrus"
	"github.com/rifflock/lfshook"
	"gitlab.com/epicglue/epicglue/app/config"
	"os"
	"sync"
)

var loggers = make(map[string]*logrus.Logger)
var mutex = &sync.Mutex{}

func GetLogger(name string) *logrus.Logger {
	if loggers[name] != nil {
		return loggers[name]
	}

	var log = logrus.New()
	if config.LoadConfig().App.LogFormat == config.LOG_FORMAT_JSON {
		log.Formatter = new(logrus.JSONFormatter)
	}

	if config.LoadConfig().App.LogLevel == "" {
		log.Level = logrus.InfoLevel
	} else {
		if config.LoadConfig().App.LogLevel == "debug" {
			log.Level = logrus.DebugLevel
		} else if config.LoadConfig().App.LogLevel == "info" {
			log.Level = logrus.InfoLevel
		} else if config.LoadConfig().App.LogLevel == "warning" {
			log.Level = logrus.WarnLevel
		} else if config.LoadConfig().App.LogLevel == "error" {
			log.Level = logrus.ErrorLevel
		} else if config.LoadConfig().App.LogLevel == "panic" {
			log.Level = logrus.PanicLevel
		}
	}

	logDir := os.Getenv("GOPATH") + "/log"

	log.Hooks.Add(lfshook.NewHook(lfshook.PathMap{
		logrus.DebugLevel: fmt.Sprintf("%s/%s_debug.log", logDir, name),
		logrus.InfoLevel:  fmt.Sprintf("%s/%s_info.log", logDir, name),
		logrus.WarnLevel:  fmt.Sprintf("%s/%s_info.log", logDir, name),
		logrus.ErrorLevel: fmt.Sprintf("%s/%s_error.log", logDir, name),
		logrus.FatalLevel: fmt.Sprintf("%s/%s_error.log", logDir, name),
		logrus.PanicLevel: fmt.Sprintf("%s/%s_error.log", logDir, name),
	}))

	mutex.Lock()

	loggers[name] = log
	mutex.Unlock()

	log.Debugf("Logger created (%s)", name)
	return loggers[name]
}
