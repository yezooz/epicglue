package cmd

import (
	"fmt"

	"github.com/spf13/cobra"
	"github.com/yezooz/common-cli/model"
	"github.com/yezooz/common-cli/output"
	"github.com/yezooz/kickstarter-cli/kickstarter"
)

// categoryCmd represents the category command
var categoryCmd = &cobra.Command{
	Use:   "category",
	Short: "Category name to fetch",
	Long:  ``,
	Run: func(cmd *cobra.Command, args []string) {
		if len(args) == 0 {
			log.Error("Category name is required")
			return
		}

		categoryName := args[0]

		if !isCategoryValid(categoryName) {
			log.Error(categoryName + " is not a valid category name")
			return
		}

		f := kickstarter.NewKickstarterRobot()
		latestItems, err := f.Category(categoryName, kickstarter.SortByMagic)
		if err != nil {
			log.Error(err.Error())
			return
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
	case CategoryArt,
		CategoryComics,
		CategoryDance,
		CategoryDesign,
		CategoryFashion,
		CategoryFilmAndVideo,
		CategoryFood,
		CategoryGames,
		CategoryHardware,
		CategoryJournalism,
		CategoryMusic,
		CategoryPhotography,
		CategoryPublishing,
		CategoryTechnology,
		CategoryTheatre:
		return true
	}

	return false
}

func init() {
	RootCmd.AddCommand(categoryCmd)

	categoryCmd.PersistentFlags().Bool(ParamRawOutput, false, "Unformatted output")
	categoryCmd.PersistentFlags().Bool(ParamJSONOutput, true, "JSON output")

	categoryCmd.PersistentFlags().Bool(ParamFirstItem, false, "Return only first item")

	categoryCmd.PersistentFlags().Int(ParamTopItems, 0, "Return first X results")
	categoryCmd.PersistentFlags().Int(ParamBottomItems, 0, "Return last X results")
}
