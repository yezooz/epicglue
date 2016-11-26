package cmd

import (
	"fmt"

	"github.com/spf13/cobra"
	"gitlab.com/epicglue/common-cli/model"
	"gitlab.com/epicglue/common-cli/output"
	"gitlab.com/epicglue/product-hunt-cli/product_hunt"
)

// todayCmd represents the today command
var todayCmd = &cobra.Command{
	Use:   "today",
	Short: "",
	Long:  ``,
	Run: func(cmd *cobra.Command, args []string) {
		if token == "" {
			panic("Token (--token) is required")
		}

		ph := product_hunt.NewProductHuntRobot(token)

		latestItems, err := ph.Today()
		if err != nil {
			log.Error(err.Error())
		}

		onlyFirst, _ := cmd.PersistentFlags().GetBool(ParamFirstItem)
		topResults, _ := cmd.PersistentFlags().GetInt(ParamTopItems)
		bottomResults, _ := cmd.PersistentFlags().GetInt(ParamBottomItems)
		outputRaw, _ := cmd.PersistentFlags().GetBool(ParamRawOutput)
		outputJSON, _ := cmd.PersistentFlags().GetBool(ParamJSONOutput)

		posts := make([]*model.Post, 0)

		for i, item := range latestItems.Items {
			if topResults > 0 && i >= topResults {
				continue
			}
			if bottomResults > 0 && i < len(latestItems.Items)-bottomResults {
				continue
			}

			posts = append(posts, item.AsModelItem())

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
			fmt.Println(posts)
		} else {
			fmt.Println(out.Posts(posts))
		}
	},
}

func init() {
	RootCmd.AddCommand(todayCmd)

	todayCmd.PersistentFlags().Bool(ParamRawOutput, false, "Unformatted output")
	todayCmd.PersistentFlags().Bool(ParamJSONOutput, true, "JSON output")

	todayCmd.PersistentFlags().Bool(ParamFirstItem, false, "Return only first item")

	todayCmd.PersistentFlags().Int(ParamTopItems, 0, "Return first X results")
	todayCmd.PersistentFlags().Int(ParamBottomItems, 0, "Return last X results")
}
