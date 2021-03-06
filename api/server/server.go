package server

import (
	"fmt"
	"github.com/gorilla/mux"
	"github.com/uber-go/zap"
	"github.com/yezooz/epicglue/api/server/endpoints"
	"github.com/yezooz/epicglue/common/config"
	"github.com/yezooz/epicglue/common/helpers"
	"net/http"
	"time"
)

const (
	APP_NAME = "EpicGlue"
	VERSION  = 1
)

var (
	log  = zap.New(zap.NewTextEncoder())
	conf = config.LoadConfig()
)

func Run() {
	r := mux.NewRouter()

	r.HandleFunc("channels", endpoints.GetChannels).Methods(http.MethodGet)
	r.HandleFunc("channel", endpoints.AddChannel).Methods(http.MethodPut)
	r.HandleFunc("channel/:id", endpoints.UpdateChannel).Methods(http.MethodPost)
	r.HandleFunc("channel/:id", endpoints.DeleteChannel).Methods(http.MethodDelete)

	r.HandleFunc("pipes", endpoints.GetPipes).Methods(http.MethodGet)
	r.HandleFunc("pipe", endpoints.AddPipe).Methods(http.MethodPut)
	r.HandleFunc("pipe/:id", endpoints.UpdatePipe).Methods(http.MethodPost)
	r.HandleFunc("pipe/:id", endpoints.DeletePipe).Methods(http.MethodDelete)

	//r.GET(getPath("items"), Log(Auth(Limit(GetItems()))))
	//r.PUT(getPath("items"), Log(Auth(Limit(AddItems))))
	//r.POST(getPath("items"), Log(Auth(Limit(UpdateItems))))
	//r.DELETE(getPath("items"), Log(Auth(DeleteItems)))
	//r.POST(getPath("items/count"), Log(Auth(Limit(Counters))))
	//
	//r.POST(getPath("login"), Log(LoginByEmail))
	//r.POST(getPath("register/email"), Log(RegisterByEmail))
	//r.POST(getPath("register/service"), Log(RegisterByService))
	//r.POST(getPath("register/device"), Log(RegisterByDevice))
	//
	//r.GET(getPath("me"), Log(Auth(Me)))
	//r.POST(getPath("feedback"), Log(Auth(Feedback)))
	//r.PUT(getPath("me/service"), Log(Auth(ConnectService)))
	//r.DELETE(getPath("me/service"), Log(Auth(DisconnectService)))

	log.Info("Server starting...")

	srv := &http.Server{
		Handler: r,
		Addr:    "127.0.0.1:8000",
		// Good practice: enforce timeouts for servers you create!
		WriteTimeout: 15 * time.Second,
		ReadTimeout:  15 * time.Second,
	}

	log.Fatal(srv.ListenAndServe().Error())
}

func getPath(url string) string {
	return fmt.Sprintf("/v%d/%s", VERSION, url)
}

func SetHeaders(w http.ResponseWriter, remaining int64) {
	w.Header().Set("X-Powered-By", APP_NAME)

	w.Header().Set("X-Rate-Limit-Limit", fmt.Sprintf("%d", conf.API.RequestLimit))
	w.Header().Set("X-Rate-Limit-Remaining", fmt.Sprintf("%d", remaining))
	w.Header().Set("X-Rate-Limit-Reset", helpers.NextFullHour(time.Now()).Format(time.RFC1123Z))
}
