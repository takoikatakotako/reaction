package database

import (
	"errors"
	"github.com/takoikatakotako/reaction/common"
	"time"
)

const (
	NoticeTableName = "notices"
	NoticeTableID   = "id"
)

type Notice struct {
	ID            string `dynamodbav:"id"`
	EnglishTitle  string `dynamodbav:"englishTitle"`
	JapaneseTitle string `dynamodbav:"japaneseTitle"`
	EnglishBody   string `dynamodbav:"englishBody"`
	JapaneseBody  string `dynamodbav:"japaneseBody"`
	// 一覧の並び順と表示日に使う
	PublishedAt string `dynamodbav:"publishedAt"`
	CreatedAt   string `dynamodbav:"createdAt"`
	UpdatedAt   string `dynamodbav:"updatedAt"`
}

func (n *Notice) SetCreatedAt(createdAt time.Time) {
	n.CreatedAt = createdAt.UTC().Format(time.RFC3339)
}

func (n *Notice) SetUpdatedAt(updatedAt time.Time) {
	n.UpdatedAt = updatedAt.UTC().Format(time.RFC3339)
}

func (n *Notice) Validate() error {
	if !IsValidUUID(n.ID) {
		return errors.New(common.ErrorInvalidValue + ": ID")
	}

	if _, err := time.Parse(time.RFC3339, n.PublishedAt); err != nil {
		return errors.New(common.ErrorInvalidValue + ": PublishedAt")
	}

	if _, err := time.Parse(time.RFC3339, n.CreatedAt); err != nil {
		return errors.New(common.ErrorInvalidValue + ": CreatedAt")
	}

	if _, err := time.Parse(time.RFC3339, n.UpdatedAt); err != nil {
		return errors.New(common.ErrorInvalidValue + ": UpdatedAt")
	}

	return nil
}
