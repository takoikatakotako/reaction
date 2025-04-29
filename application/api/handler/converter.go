package handler

import (
	"github.com/takoikatakotako/reaction/api/handler/response"
	"github.com/takoikatakotako/reaction/api/service/output"
)

func convertToResponseReactions(reactions []output.Reaction) []response.Reaction {
	responseReactions := make([]response.Reaction, 0)
	for i := 0; i < len(reactions); i++ {
		reactionOutput := convertToResponseReaction(reactions[i])
		responseReactions = append(responseReactions, reactionOutput)
	}
	return responseReactions
}

func convertToResponseReaction(reaction output.Reaction) response.Reaction {
	return response.Reaction{
		ID:                      reaction.ID,
		EnglishName:             reaction.EnglishName,
		JapaneseName:            reaction.JapaneseName,
		ThumbnailImageURL:       reaction.ThumbnailImageName,
		GeneralFormulaImageURLs: reaction.GeneralFormulaImageNames,
		MechanismsImageURLs:     reaction.MechanismsImageNames,
		ExampleImageURLs:        reaction.ExampleImageNames,
		SupplementsImageURLs:    reaction.SupplementsImageNames,
		Suggestions:             reaction.Suggestions,
		Reactants:               reaction.Reactants,
		Products:                reaction.Products,
		YoutubeUrls:             reaction.YoutubeUrls,
	}
}
