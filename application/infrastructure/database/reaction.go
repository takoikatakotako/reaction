package database

import (
	"errors"
	"github.com/takoikatakotako/reaction/common"
	"time"
)

const (
	ReactionTableName = "reactions"
	ReactionTableID   = "id"
)

type Reaction struct {
	ID                       string   `dynamodbav:"id"`
	EnglishName              string   `dynamodbav:"englishName"`
	JapaneseName             string   `dynamodbav:"japaneseName"`
	ThumbnailImageName       string   `dynamodbav:"thumbnailImageName"`
	GeneralFormulaImageNames []string `dynamodbav:"generalFormulaImageNames"`
	MechanismsImageNames     []string `dynamodbav:"mechanismsImageNames"`
	ExampleImageNames        []string `dynamodbav:"exampleImageNames"`
	SupplementsImageNames    []string `dynamodbav:"supplementsImageNames"`
	Suggestions              []string `dynamodbav:"suggestions"`
	Reactants                []string `dynamodbav:"reactants"`
	Products                 []string `dynamodbav:"products"`
	YoutubeUrls              []string `dynamodbav:"youtubeUrls"`
	CreatedAt                string   `dynamodbav:"createdAt"`
	UpdatedAt                string   `dynamodbav:"updatedAt"`
}

func (r *Reaction) SetCreatedAt(createdAt time.Time) {
	r.CreatedAt = createdAt.UTC().Format(time.RFC3339)
}

func (r *Reaction) SetUpdatedAt(updatedAt time.Time) {
	r.UpdatedAt = updatedAt.UTC().Format(time.RFC3339)
}

func (r *Reaction) Validate() error {
	// ID is UUID
	if !IsValidUUID(r.ID) {
		return errors.New(common.ErrorInvalidValue + ": ID")
	}

	// EnglishName is 0 < size < 255
	if 0 < len(r.EnglishName) && len(r.EnglishName) < 255 {
	} else {
		return errors.New(common.ErrorInvalidValue + ": EnglishName")
	}

	// JapaneseName is 0 < size < 255
	if 0 < len(r.JapaneseName) && len(r.JapaneseName) < 255 {
	} else {
		return errors.New(common.ErrorInvalidValue + ": JapaneseName")
	}

	// ThumbnailImageURL
	if !IsValidUUIDImageName(r.ThumbnailImageName) {
		return errors.New(common.ErrorInvalidValue + ": ThumbnailImageURL")
	}

	// CreatedAt
	_, err := time.Parse(time.RFC3339, r.CreatedAt)
	if err != nil {
		return errors.New(common.ErrorInvalidValue + ": CreatedAt")
	}

	// UpdatedAt
	_, err = time.Parse(time.RFC3339, r.UpdatedAt)
	if err != nil {
		return errors.New(common.ErrorInvalidValue + ": UpdatedAt")
	}

	return nil
}
