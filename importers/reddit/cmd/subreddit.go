package cmd

import (
	"fmt"

	"github.com/spf13/cobra"
	"github.com/yezooz/common-cli/model"
	"github.com/yezooz/common-cli/output"
	"github.com/yezooz/reddit-cli/reddit"
)

// subredditCmd represents the subreddit command
var subredditCmd = &cobra.Command{
	Use:   "subreddit",
	Short: "",
	Long:  ``,
	Run: func(cmd *cobra.Command, args []string) {
		if len(args) == 0 {
			fmt.Println("Name of subreddit is required")
			return
		}

		subreddit := args[0]

		r := reddit.NewRedditRobot()
		fetchedItems, err := r.Subreddit(subreddit)
		if err != nil {
			return
		}

		onlyFirst, _ := cmd.PersistentFlags().GetBool(ParamFirstItem)
		topResults, _ := cmd.PersistentFlags().GetInt(ParamTopItems)
		bottomResults, _ := cmd.PersistentFlags().GetInt(ParamBottomItems)
		outputRaw, _ := cmd.PersistentFlags().GetBool(ParamRawOutput)
		outputJSON, _ := cmd.PersistentFlags().GetBool(ParamJSONOutput)

		items := make([]*model.Post, 0)

		for i, obj := range fetchedItems.Data.Children {
			if topResults > 0 && i >= topResults {
				continue
			}
			if bottomResults > 0 && i < len(fetchedItems.Data.Children)-bottomResults {
				continue
			}

			items = append(items, obj.Data.ToModel())

			if onlyFirst {
				break
			}
		}

		var out output.Output = nil
		if outputRaw {
			out = output.NewRawOutput()
		} else if outputJSON {
			out = output.NewJSONOutput()
		}

		if out == nil {
			fmt.Println(items)
		} else {
			fmt.Println(out.Posts(items))
		}
	},
}

func init() {
	RootCmd.AddCommand(subredditCmd)

	subredditCmd.PersistentFlags().Bool(ParamRawOutput, false, "Unformatted output")
	subredditCmd.PersistentFlags().Bool(ParamJSONOutput, true, "JSON output")

	subredditCmd.PersistentFlags().Bool(ParamFirstItem, false, "Return only first item")

	subredditCmd.PersistentFlags().Int(ParamTopItems, 0, "Return first X results")
	subredditCmd.PersistentFlags().Int(ParamBottomItems, 0, "Return last X results")
}
