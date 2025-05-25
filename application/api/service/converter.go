package service

import (
	"fmt"
	"github.com/takoikatakotako/reaction/api/service/output"
	"github.com/takoikatakotako/reaction/infrastructure/database"
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
	thumbnailImageURL := resourceBaseURL + "/" + reaction.ThumbnailImageName

	generalFormulaImageURLs := make([]string, 0)
	for _, generalFormulaImageName := range reaction.GeneralFormulaImageNames {
		generalFormulaImageURL := fmt.Sprintf("%s/%s", resourceBaseURL, generalFormulaImageName)
		generalFormulaImageURLs = append(generalFormulaImageURLs, generalFormulaImageURL)
	}

	mechanismsImageURLs := make([]string, 0)
	for _, mechanismsImageName := range reaction.MechanismsImageNames {
		mechanismsImageURL := fmt.Sprintf("%s/%s", resourceBaseURL, mechanismsImageName)
		mechanismsImageURLs = append(mechanismsImageURLs, mechanismsImageURL)
	}

	exampleImageURLs := make([]string, 0)
	for _, exampleImageName := range reaction.ExampleImageNames {
		exampleImagURL := fmt.Sprintf("%s/%s", resourceBaseURL, exampleImageName)
		exampleImageURLs = append(exampleImageURLs, exampleImagURL)
	}

	supplementsImageURLs := make([]string, 0)
	for _, supplementsImageName := range reaction.SupplementsImageNames {
		supplementsImageURL := fmt.Sprintf("%s/%s", resourceBaseURL, supplementsImageName)
		supplementsImageURLs = append(supplementsImageURLs, supplementsImageURL)
	}

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
