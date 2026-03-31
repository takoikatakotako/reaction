package database

import (
	"errors"
	"github.com/takoikatakotako/reaction/common"
	"time"
)

const (
	QuestionTableName = "questions"
	QuestionTableID   = "id"
)

type Question struct {
	ID                 string   `dynamodbav:"id"`
	ProblemImageNames  []string `dynamodbav:"problemImageNames"`
	SolutionImageNames []string `dynamodbav:"solutionImageNames"`
	References         []string `dynamodbav:"references"`
	CreatedAt          string   `dynamodbav:"createdAt"`
	UpdatedAt          string   `dynamodbav:"updatedAt"`
}

func (q *Question) SetCreatedAt(createdAt time.Time) {
	q.CreatedAt = createdAt.UTC().Format(time.RFC3339)
}

func (q *Question) SetUpdatedAt(updatedAt time.Time) {
	q.UpdatedAt = updatedAt.UTC().Format(time.RFC3339)
}

func (q *Question) Validate() error {
	if !IsValidUUID(q.ID) {
		return errors.New(common.ErrorInvalidValue + ": ID")
	}

	_, err := time.Parse(time.RFC3339, q.CreatedAt)
	if err != nil {
		return errors.New(common.ErrorInvalidValue + ": CreatedAt")
	}

	_, err = time.Parse(time.RFC3339, q.UpdatedAt)
	if err != nil {
		return errors.New(common.ErrorInvalidValue + ": UpdatedAt")
	}

	return nil
}
