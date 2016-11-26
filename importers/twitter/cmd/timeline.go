package cmd

import (
	"fmt"

	"github.com/epic-glue/common-cli/model"
	"github.com/epic-glue/common-cli/output"
	"github.com/spf13/cobra"
)

// timelineCmd represents the posts command
var timelineCmd = &cobra.Command{
	Use:   "timeline",
	Short: "",
	Long:  ``,
	Run: func(cmd *cobra.Command, args []string) {
		latestItems, err := buildTwitterRobot(cmd).Timeline()
		if err != nil {
			log.Error(err.Error())
		}

		topResults, _ := cmd.PersistentFlags().GetInt(ParamTopItems)
		bottomResults, _ := cmd.PersistentFlags().GetInt(ParamBottomItems)
		outputRaw, _ := cmd.PersistentFlags().GetBool(ParamRawOutput)
		outputJSON, _ := cmd.PersistentFlags().GetBool(ParamJSONOutput)

		posts := make([]*model.Post, 0)

		for i, item := range latestItems {
			if topResults > 0 && i >= topResults {
				continue
			}
			if bottomResults > 0 && i < len(latestItems)-bottomResults {
				continue
			}

			posts = append(posts, item.AsModelItem())
		}

		var out output.Output = nil
		if outputRaw {
			out = output.NewRawOutput()
		} else if outputJSON {
			out = output.NewJSONOutput()
		}

		if out == nil {
			fmt.Println(posts)
		} else {
			fmt.Println(out.Posts(posts))
		}
	},
}

func init() {
	RootCmd.AddCommand(timelineCmd)

	timelineCmd.PersistentFlags().Bool(ParamRawOutput, false, "Unformatted output")
	timelineCmd.PersistentFlags().Bool(ParamJSONOutput, true, "JSON output")

	timelineCmd.PersistentFlags().Bool(ParamFirstItem, false, "Return only first item")

	timelineCmd.PersistentFlags().Int(ParamTopItems, 0, "Return first X results")
	timelineCmd.PersistentFlags().Int(ParamBottomItems, 0, "Return last X results")
}
