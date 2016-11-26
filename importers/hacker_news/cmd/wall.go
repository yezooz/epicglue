package cmd

import (
	"fmt"

	"github.com/spf13/cobra"
	"gitlab.com/epicglue/common-cli/model"
	"gitlab.com/epicglue/common-cli/output"
	"gitlab.com/epicglue/hacker-news-cli/hacker_news"
)

// wallCmd represents the posts command
var wallCmd = &cobra.Command{
	Use:   "wall",
	Short: "A brief description of your command",
	Long: `A longer description that spans multiple lines and likely contains examples
and usage of using your command. For example:

Cobra is a CLI library for Go that empowers applications.
This application is a tool to generate the needed files
to quickly create a Cobra application.`,
	Run: func(cmd *cobra.Command, args []string) {
		if len(args) == 0 {
			fmt.Println("Category name is required")
			return
		}

		categoryName := args[0]

		if !isCategoryValid(categoryName) {
			fmt.Println(categoryName + " is not a valid category name")
			return
		}

		onlyFirst, _ := cmd.PersistentFlags().GetBool(ParamFirstItem)
		topResults, _ := cmd.PersistentFlags().GetInt(ParamTopItems)
		bottomResults, _ := cmd.PersistentFlags().GetInt(ParamBottomItems)
		outputRaw, _ := cmd.PersistentFlags().GetBool(ParamRawOutput)
		outputJSON, _ := cmd.PersistentFlags().GetBool(ParamJSONOutput)

		limit := 0
		if onlyFirst {
			limit = 1
		} else if topResults > 0 {
			limit = topResults
		}

		fetchedItems, err := fetcher(categoryName, limit)()
		if err != nil {
			log.Error(err.Error())
		}

		posts := make([]*model.Post, 0)

		for i, item := range fetchedItems {
			if topResults > 0 && i >= topResults {
				continue
			}
			if bottomResults > 0 && i < len(fetchedItems)-bottomResults {
				continue
			}

			posts = append(posts, item.ToModel())

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

func isCategoryValid(category string) bool {
	switch category {
	case CategoryNew,
		CategoryAsk,
		CategoryShow,
		CategoryTop,
		CategoryBest,
		CategoryJobs:
		return true
	}

	return false
}

func fetcher(category string, limit int) func() ([]*hacker_news.Item, error) {
	f := hacker_news.NewHackerNewsRobot()
	if limit > 0 {
		f.Limit = limit
	}

	switch category {
	case CategoryNew:
		return f.Latest
	case CategoryAsk:
		return f.Ask
	case CategoryShow:
		return f.Show
	case CategoryTop:
		return f.Top
	case CategoryBest:
		return f.Best
	case CategoryJobs:
		return f.Jobs
	}

	panic("Unrecognized category")
}

func init() {
	RootCmd.AddCommand(wallCmd)

	wallCmd.PersistentFlags().Bool(ParamRawOutput, false, "Unformatted output")
	wallCmd.PersistentFlags().Bool(ParamJSONOutput, true, "JSON output")

	wallCmd.PersistentFlags().Bool(ParamFirstItem, false, "Return only first item")

	wallCmd.PersistentFlags().Int(ParamTopItems, 0, "Return first X results")
	wallCmd.PersistentFlags().Int(ParamBottomItems, 0, "Return last X results")

}
