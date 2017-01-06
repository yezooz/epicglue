package server

import (
	"github.com/uber-go/zap"
)

const (
	APP_NAME = "EpicGlue"
	VERSION  = 1
)

var (
	log = zap.New(zap.NewTextEncoder())
	//conf = config.LoadConfig()
)

//func Run() {
//	r := mux.NewRouter()
//
//	r.HandleFunc("channels", endpoints.GetChannels).Methods(http.MethodGet)
//	r.HandleFunc("channel", endpoints.AddChannel).Methods(http.MethodPut)
//	r.HandleFunc("channel/{id}", endpoints.UpdateChannel).Methods(http.MethodPost)
//	r.HandleFunc("channel/{id}", endpoints.DeleteChannel).Methods(http.MethodDelete)
//
//	log.Info("Server starting...")
//
//	srv := &http.Server{
//		Handler: r,
//		Addr:    "127.0.0.1:8000",
//		// Good practice: enforce timeouts for servers you create!
//		WriteTimeout: 15 * time.Second,
//		ReadTimeout:  15 * time.Second,
//	}
//
//	log.Fatal(srv.ListenAndServe().Error())
//}
//
//func getPath(url string) string {
//	return fmt.Sprintf("/v%d/%s", VERSION, url)
//}
//
//func SetHeaders(w http.ResponseWriter, remaining int64) {
//	w.Header().Set("X-Powered-By", APP_NAME)
//
//	w.Header().Set("X-Rate-Limit-Limit", fmt.Sprintf("%d", conf.API.RequestLimit))
//	w.Header().Set("X-Rate-Limit-Remaining", fmt.Sprintf("%d", remaining))
//	w.Header().Set("X-Rate-Limit-Reset", helpers.NextFullHour(time.Now()).Format(time.RFC1123Z))
//}
