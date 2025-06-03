package service

import (
	"fmt"
	"github.com/takoikatakotako/reaction/api/service/output"
	"github.com/takoikatakotako/reaction/infrastructure/database"
	"github.com/takoikatakotako/reaction/infrastructure/file"
)

func convertToOutputReactions(reactions []database.Reaction, resourceBaseURL string) []output.Reaction {
	reactionOutputs := make([]output.Reaction, 0)
	for i := 0; i < len(reactions); i++ {
		reactionOutput := convertToOutputReaction(reactions[i], resourceBaseURL)
		reactionOutputs = append(reactionOutputs, reactionOutput)
	}
	return reactionOutputs
}

func convertToOutputReaction(reaction database.Reaction, resourceBaseURL string) output.Reaction {
	thumbnailImageURL := convertImageNameToImageURL(reaction.ThumbnailImageName, resourceBaseURL)
	generalFormulaImageURLs := convertImageNamesToImageURLs(reaction.GeneralFormulaImageNames, resourceBaseURL)
	mechanismsImageURLs := convertImageNamesToImageURLs(reaction.MechanismsImageNames, resourceBaseURL)
	exampleImageURLs := convertImageNamesToImageURLs(reaction.ExampleImageNames, resourceBaseURL)
	supplementsImageURLs := convertImageNamesToImageURLs(reaction.SupplementsImageNames, resourceBaseURL)

	return output.Reaction{
		ID:                      reaction.ID,
		EnglishName:             reaction.EnglishName,
		JapaneseName:            reaction.JapaneseName,
		ThumbnailImageURL:       thumbnailImageURL,
		GeneralFormulaImageURLs: generalFormulaImageURLs,
		MechanismsImageURLs:     mechanismsImageURLs,
		ExampleImageURLs:        exampleImageURLs,
		SupplementsImageURLs:    supplementsImageURLs,
		Suggestions:             reaction.Suggestions,
		Reactants:               reaction.Reactants,
		Products:                reaction.Products,
		YoutubeUrls:             reaction.YoutubeUrls,
	}
}

func convertToFileReaction(reaction database.Reaction, resourceBaseURL string) file.Reaction {
	thumbnailImageURL := convertImageNameToImageURL(reaction.ThumbnailImageName, resourceBaseURL)
	generalFormulaImageURLs := convertImageNamesToImageURLs(reaction.GeneralFormulaImageNames, resourceBaseURL)
	mechanismsImageURLs := convertImageNamesToImageURLs(reaction.MechanismsImageNames, resourceBaseURL)
	exampleImageURLs := convertImageNamesToImageURLs(reaction.ExampleImageNames, resourceBaseURL)
	supplementsImageURLs := convertImageNamesToImageURLs(reaction.SupplementsImageNames, resourceBaseURL)

	return file.Reaction{
		ID:                      reaction.ID,
		EnglishName:             reaction.EnglishName,
		JapaneseName:            reaction.JapaneseName,
		ThumbnailImageURL:       thumbnailImageURL,
		GeneralFormulaImageURLs: generalFormulaImageURLs,
		MechanismsImageURLs:     mechanismsImageURLs,
		ExampleImageURLs:        exampleImageURLs,
		SupplementsImageURLs:    supplementsImageURLs,
		Suggestions:             reaction.Suggestions,
		Reactants:               reaction.Reactants,
		Products:                reaction.Products,
		YoutubeUrls:             reaction.YoutubeUrls,
	}
}

func convertImageNamesToImageURLs(imageNames []string, resourceBaseURL string) []string {
	imageURLs := make([]string, 0)
	for _, imageName := range imageNames {
		imageURL := convertImageNameToImageURL(imageName, resourceBaseURL)
		imageURLs = append(imageURLs, imageURL)
	}
	return imageURLs
}

func convertImageNameToImageURL(imageName string, resourceBaseURL string) string {
	return fmt.Sprintf("%s/%s", resourceBaseURL, imageName)
}

// 2文字目移行の文字を*に変換
func maskAuthToken(authToken string) string {
	length := len(authToken)
	var r = ""
	for i := 0; i < length; i++ {
		if i == 0 {
			r += authToken[0:1]
		} else if i == 1 {
			r += authToken[1:2]
		} else {
			r += "*"
		}
	}
	return r
}
