package cmd

import (
	"github.com/epic-glue/twitter-cli/twitter"
	"github.com/spf13/cobra"
)

func checkRequiredFields() {
	if userToken == "" {
		panic("Token (--token) is required")
	}

	if userSecret == "" {
		panic("Secret (--secret) is required")
	}

	if appKey == "" {
		panic("App Key (--app-key is required")
	}

	if appSecret == "" {
		panic("App Secret (--app-secret) is required")
	}
}

func buildTwitterRobot(cmd *cobra.Command) *twitter.TwitterRobot {
	checkRequiredFields()

	onlyFirst, _ := cmd.PersistentFlags().GetBool(ParamFirstItem)
	topResults, _ := cmd.PersistentFlags().GetInt(ParamTopItems)
	bottomResults, _ := cmd.PersistentFlags().GetInt(ParamBottomItems)

	t := twitter.NewTwitterRobot(userToken, userSecret, appKey, appSecret)

	if onlyFirst {
		t.SetLimit(1)
	} else if topResults > 0 && bottomResults == 0 {
		t.SetLimit(topResults)
	}

	return t
}
