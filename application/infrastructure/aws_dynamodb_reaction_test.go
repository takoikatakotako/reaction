package infrastructure

import (
	"github.com/google/uuid"
	"github.com/stretchr/testify/assert"
	"github.com/takoikatakotako/reaction/infrastructure/database"
	"testing"
	"time"
)

func TestAWS_Reaction_Scenario(t *testing.T) {
	// Infrastructure
	infra := AWS{Profile: "local"}

	id := uuid.NewString()
	imageName := uuid.NewString() + ".png"
	currentTime := time.Now().UTC()
	reaction := database.Reaction{
		ID:                 id,
		EnglishName:        "ReactionName",
		JapaneseName:       "日本語名",
		ThumbnailImageName: imageName,
		CreatedAt:          currentTime.Format(time.RFC3339),
		UpdatedAt:          currentTime.Format(time.RFC3339),
	}

	err := infra.InsertReaction(reaction)
	if err != nil {
		t.Errorf("unexpected error: %v", err)
	}

	getReaction, err := infra.GetReaction(id)
	if err != nil {
		t.Errorf("unexpected error: %v", err)
	}

	assert.Equal(t, id, getReaction.ID)
	assert.Equal(t, imageName, getReaction.ThumbnailImageName)
	assert.Equal(t, currentTime.Format(time.RFC3339), getReaction.CreatedAt)
	assert.Equal(t, currentTime.Format(time.RFC3339), getReaction.UpdatedAt)
}

func TestAWS_GetReactions(t *testing.T) {
	// Infrastructure
	infra := AWS{Profile: "local"}

	// insert reaction0
	currentTime0 := time.Now()
	reaction0 := database.Reaction{
		ID:                 uuid.NewString(),
		EnglishName:        "ReactionName",
		JapaneseName:       "日本語名",
		ThumbnailImageName: uuid.NewString() + ".png",
		CreatedAt:          currentTime0.UTC().Format(time.RFC3339),
		UpdatedAt:          currentTime0.UTC().Format(time.RFC3339),
	}

	err := infra.InsertReaction(reaction0)
	if err != nil {
		t.Errorf("unexpected error: %v", err)
	}

	// insert reaction1
	currentTime1 := time.Now()
	reaction1 := database.Reaction{
		ID:                 uuid.NewString(),
		EnglishName:        "ReactionName",
		JapaneseName:       "日本語名",
		ThumbnailImageName: uuid.NewString() + ".png",
		CreatedAt:          currentTime1.UTC().Format(time.RFC3339),
		UpdatedAt:          currentTime1.UTC().Format(time.RFC3339),
	}

	err = infra.InsertReaction(reaction1)
	if err != nil {
		t.Errorf("unexpected error: %v", err)
	}

	// insert reaction2
	currentTime2 := time.Now()
	reaction2 := database.Reaction{
		ID:                 uuid.NewString(),
		EnglishName:        "ReactionName",
		JapaneseName:       "日本語名",
		ThumbnailImageName: uuid.NewString() + ".png",
		CreatedAt:          currentTime2.UTC().Format(time.RFC3339),
		UpdatedAt:          currentTime2.UTC().Format(time.RFC3339),
	}

	err = infra.InsertReaction(reaction2)
	if err != nil {
		t.Errorf("unexpected error: %v", err)
	}

	// 反応機構取得
	reactions, err := infra.GetReactions()
	if err != nil {
		t.Errorf("unexpected error: %v", err)
	}

	// フィルター対象を絞る
	valueSet := make(map[string]struct{})
	valueSet[reaction0.ID] = struct{}{}
	valueSet[reaction1.ID] = struct{}{}
	valueSet[reaction2.ID] = struct{}{}

	// 抽出を行う
	var results []database.Reaction
	for _, reaction := range reactions {
		if _, exists := valueSet[reaction.ID]; exists {
			results = append(results, reaction)
		}
	}

	// assert
	assert.Equal(t, 3, len(results))
}
