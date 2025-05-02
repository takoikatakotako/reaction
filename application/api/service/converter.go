package service

import (
	"github.com/takoikatakotako/reaction/api/service/output"
	"github.com/takoikatakotako/reaction/infrastructure/database"
)

func convertToOutputReactions(reactions []database.Reaction) []output.Reaction {
	reactionOutputs := make([]output.Reaction, 0)
	for i := 0; i < len(reactions); i++ {
		reactionOutput := convertToOutputReaction(reactions[i])
		reactionOutputs = append(reactionOutputs, reactionOutput)
	}
	return reactionOutputs
}

func convertToOutputReaction(reaction database.Reaction) output.Reaction {
	return output.Reaction{
		ID:                       reaction.ID,
		EnglishName:              reaction.EnglishName,
		JapaneseName:             reaction.JapaneseName,
		ThumbnailImageName:       reaction.ThumbnailImageName,
		GeneralFormulaImageNames: reaction.GeneralFormulaImageNames,
		MechanismsImageNames:     reaction.MechanismsImageNames,
		ExampleImageNames:        reaction.ExampleImageNames,
		SupplementsImageNames:    reaction.SupplementsImageNames,
		Suggestions:              reaction.Suggestions,
		Reactants:                reaction.Reactants,
		Products:                 reaction.Products,
		YoutubeUrls:              reaction.YoutubeUrls,
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
