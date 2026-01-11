package service

import (
	"github.com/google/uuid"
	"github.com/takoikatakotako/reaction/api/service/input"
	"github.com/takoikatakotako/reaction/api/service/output"
	"github.com/takoikatakotako/reaction/infrastructure"
	"github.com/takoikatakotako/reaction/infrastructure/database"
	"log/slog"
	"time"
)

type Reaction struct {
	AWS                infrastructure.AWS
	ResourceBucketName string
	ResourceBaseURL    string
	DistributionID     string
}

func (a *Reaction) GetReactions() ([]output.Reaction, error) {
	// Get Reactions
	reactions, err := a.AWS.GetReactions()
	if err != nil {
		slog.Error(err.Error())
		return []output.Reaction{}, err
	}

	// Convert
	outputReactions := convertToOutputReactions(reactions, a.ResourceBaseURL)

	// データベースで既にソート済み
	return outputReactions, nil
}

func (a *Reaction) GetReaction(input input.GetReaction) (output.Reaction, error) {
	reaction, err := a.AWS.GetReaction(input.ID)
	if err != nil {
		return output.Reaction{}, err
	}
	outputReaction := convertToOutputReaction(reaction, a.ResourceBaseURL)
	return outputReaction, nil
}

func (a *Reaction) AddReaction(input input.AddReaction) error {
	reaction := database.Reaction{
		ID:                       uuid.NewString(),
		EnglishName:              input.EnglishName,
		JapaneseName:             input.JapaneseName,
		ThumbnailImageName:       input.ThumbnailImageName,
		GeneralFormulaImageNames: input.GeneralFormulaImageNames,
		MechanismsImageNames:     input.MechanismsImageNames,
		ExampleImageNames:        input.ExampleImageNames,
		SupplementsImageNames:    input.SupplementsImageNames,
		Suggestions:              input.Suggestions,
		Reactants:                input.Reactants,
		Products:                 input.Products,
		YoutubeUrls:              input.YoutubeUrls,
	}
	currentTime := time.Now()
	reaction.SetCreatedAt(currentTime)
	reaction.SetUpdatedAt(currentTime)

	err := a.AWS.InsertReaction(reaction)
	if err != nil {
		return err
	}
	return nil
}

func (a *Reaction) EditReaction(input input.EditReaction) error {
	currentReaction, err := a.AWS.GetReaction(input.ID)
	if err != nil {
		return err
	}

	reaction := database.Reaction{
		ID:                       currentReaction.ID,
		EnglishName:              input.EnglishName,
		JapaneseName:             input.JapaneseName,
		ThumbnailImageName:       input.ThumbnailImageName,
		GeneralFormulaImageNames: input.GeneralFormulaImageNames,
		MechanismsImageNames:     input.MechanismsImageNames,
		ExampleImageNames:        input.ExampleImageNames,
		SupplementsImageNames:    input.SupplementsImageNames,
		Suggestions:              input.Suggestions,
		Reactants:                input.Reactants,
		Products:                 input.Products,
		YoutubeUrls:              input.YoutubeUrls,
		CreatedAt:                currentReaction.CreatedAt,
	}
	currentTime := time.Now()
	reaction.SetUpdatedAt(currentTime)

	err = a.AWS.UpdateReaction(reaction)
	if err != nil {
		return err
	}
	return nil
}

func (a *Reaction) DeleteReaction(input input.DeleteReaction) error {
	err := a.AWS.DeleteReaction(input.ID)
	if err != nil {
		return err
	}
	return nil
}

