package main

import (
	"fmt"
	"github.com/codegangsta/cli"
	"github.com/ianschenck/envflag"
	_ "github.com/joho/godotenv/autoload"
	"github.com/uber-go/zap"
	"github.com/yezooz/contrib/ginzap"
	"github.com/yezooz/epicglue/api/router"
	"github.com/yezooz/epicglue/api/router/middleware"
	"github.com/yezooz/epicglue/api/version"
	"net/http"
	"os"
	"time"
)

var apiCmd = cli.Command{
	Name:  "api",
	Usage: "starts EpicGlue server",
	Action: func(c *cli.Context) {
		if err := api(c); err != nil {
			fmt.Println(err.Error())
		}
	},
	Flags: []cli.Flag{
		cli.BoolFlag{
			EnvVar: "EG_DEBUG",
			Name:   "debug",
			Usage:  "start the server in debug mode",
		},
	},
}

func api(c *cli.Context) error {
	var log *zap.Logger = &zap.New(
		zap.NewTextEncoder(),
		zap.DebugLevel,
	)

	// debug level if requested by user
	//if c.Bool("debug") {
	//	log  = zap.New(
	//		zap.NewTextEncoder(),
	//		zap.DebugLevel,
	//	)
	//} else {
	//	log  = zap.New(
	//		zap.NewTextEncoder(),
	//		zap.WarnLevel,
	//	)
	//}

	// setup the server and start the listener
	handler := router.Load(
		ginzap.Ginzap(log, time.RFC3339, true),
		middleware.Version,
		middleware.Cache(c),
		middleware.Store(c),
	)

	// start the server without tls enabled
	return http.ListenAndServe(
		c.String("server-addr"),
		handler,
	)
}

func main() {
	envflag.Parse()

	app := cli.NewApp()
	app.Name = "epicglue"
	app.Version = version.Version
	app.Usage = "command line utility"
	app.Flags = []cli.Flag{
		cli.StringFlag{
			Name:   "t, token",
			Usage:  "server auth token",
			EnvVar: "DRONE_TOKEN",
		},
		cli.StringFlag{
			Name:   "s, server",
			Usage:  "server location",
			EnvVar: "DRONE_SERVER",
		},
	}
	app.Commands = []cli.Command{
		apiCmd,
	}

	app.Run(os.Args)
}
