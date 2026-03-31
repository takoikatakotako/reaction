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
		ThumbnailImageURL:       reaction.ThumbnailImageURL,
		GeneralFormulaImageURLs: reaction.GeneralFormulaImageURLs,
		MechanismsImageURLs:     reaction.MechanismsImageURLs,
		ExampleImageURLs:        reaction.ExampleImageURLs,
		SupplementsImageURLs:    reaction.SupplementsImageURLs,
		Suggestions:             reaction.Suggestions,
		Reactants:               reaction.Reactants,
		Products:                reaction.Products,
		YoutubeUrls:             reaction.YoutubeUrls,
	}
}

func convertToResponseQuestions(questions []output.Question) []response.Question {
	responseQuestions := make([]response.Question, 0)
	for i := 0; i < len(questions); i++ {
		questionOutput := convertToResponseQuestion(questions[i])
		responseQuestions = append(responseQuestions, questionOutput)
	}
	return responseQuestions
}

func convertToResponseQuestion(question output.Question) response.Question {
	return response.Question{
		ID:                question.ID,
		ProblemImageURLs:  question.ProblemImageURLs,
		SolutionImageURLs: question.SolutionImageURLs,
		References:        question.References,
	}
}
