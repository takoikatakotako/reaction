package service

import (
	"encoding/json"
	"fmt"
	"github.com/google/uuid"
	"github.com/takoikatakotako/reaction/api/service/input"
	"github.com/takoikatakotako/reaction/api/service/output"
	"github.com/takoikatakotako/reaction/infrastructure"
	"github.com/takoikatakotako/reaction/infrastructure/database"
	"github.com/takoikatakotako/reaction/infrastructure/file"
	"log/slog"
	"sort"
	"time"
)

type Reaction struct {
	AWS                infrastructure.AWS
	ResourceBucketName string
	ResourceBaseURL    string
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

	// Sort
	sort.Slice(outputReactions, func(i, j int) bool {
		return outputReactions[i].EnglishName < outputReactions[j].EnglishName
	})
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

func (a *Reaction) GenerateReactions() error {
	reactions, err := a.AWS.GetReactions()
	if err != nil {
		return err
	}

	// 各々のファイルを保存
	fileReactions := make([]file.Reaction, 0)
	for _, v := range reactions {
		fileReaction := convertToFileReaction(v, a.ResourceBaseURL)
		bytes, err := json.Marshal(fileReaction)
		if err != nil {
			return err
		}

		objectKey := fmt.Sprintf("resource/reaction/%s.json", v.ID)
		err = a.AWS.PutObject(a.ResourceBucketName, objectKey, bytes, "application/json")
		if err != nil {
			return err
		}

		fileReactions = append(fileReactions, fileReaction)
	}

	// 全体をソートを行う
	sort.Slice(fileReactions, func(i, j int) bool {
		return fileReactions[i].EnglishName < fileReactions[j].EnglishName
	})

	// 全体のリストを保存
	fileListReactions := file.Reactions{
		Reactions: fileReactions,
	}
	bytes, err := json.Marshal(fileListReactions)
	objectKey := "resource/reaction/reactions.json"
	err = a.AWS.PutObject(a.ResourceBucketName, objectKey, bytes, "application/json")
	if err != nil {
		return err
	}
	return nil
}
