package main

//var apiCmd = cli.Command{
//	Name:  "api",
//	Usage: "starts EpicGlue server",
//	Action: func(c *cli.Context) {
//		if err := api(c); err != nil {
//			fmt.Println(err.Error())
//		}
//	},
//	Flags: []cli.Flag{
//		cli.BoolFlag{
//			EnvVar: "EG_DEBUG",
//			Name:   "debug",
//			Usage:  "start the server in debug mode",
//		},
//	},
//}
//
//func api(c *cli.Context) error {
//	var log *zap.Logger = &zap.New(
//		zap.NewTextEncoder(),
//		zap.DebugLevel,
//	)
//
//	// debug level if requested by user
//	//if c.Bool("debug") {
//	//	log  = zap.New(
//	//		zap.NewTextEncoder(),
//	//		zap.DebugLevel,
//	//	)
//	//} else {
//	//	log  = zap.New(
//	//		zap.NewTextEncoder(),
//	//		zap.WarnLevel,
//	//	)
//	//}
//
//	// setup the server and start the listener
//	handler := router.Load(
//		ginzap.Ginzap(log, time.RFC3339, true),
//		middleware.Version,
//		middleware.Cache(c),
//		middleware.Store(c),
//	)
//
//	// start the server without tls enabled
//	return http.ListenAndServe(
//		c.String("server-addr"),
//		handler,
//	)
//}
