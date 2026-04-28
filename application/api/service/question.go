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

type Question struct {
	AWS                infrastructure.AWS
	ResourceBucketName string
	ResourceBaseURL    string
	DistributionID     string
}

func (q *Question) GetQuestions() ([]output.Question, error) {
	questions, err := q.AWS.GetQuestions()
	if err != nil {
		slog.Error(err.Error())
		return []output.Question{}, err
	}

	outputQuestions := convertToOutputQuestions(questions, q.ResourceBaseURL)
	return outputQuestions, nil
}

func (q *Question) GetQuestion(input input.GetQuestion) (output.Question, error) {
	question, err := q.AWS.GetQuestion(input.ID)
	if err != nil {
		return output.Question{}, err
	}
	outputQuestion := convertToOutputQuestion(question, q.ResourceBaseURL)
	return outputQuestion, nil
}

func (q *Question) AddQuestion(input input.AddQuestion) error {
	question := database.Question{
		ID:                 uuid.NewString(),
		Order:              input.Order,
		ProblemImageNames:  input.ProblemImageNames,
		SolutionImageNames: input.SolutionImageNames,
		References:         input.References,
	}
	currentTime := time.Now()
	question.SetCreatedAt(currentTime)
	question.SetUpdatedAt(currentTime)

	err := q.AWS.InsertQuestion(question)
	if err != nil {
		return err
	}
	return nil
}

func (q *Question) EditQuestion(input input.EditQuestion) error {
	currentQuestion, err := q.AWS.GetQuestion(input.ID)
	if err != nil {
		return err
	}

	question := database.Question{
		ID:                 currentQuestion.ID,
		Order:              input.Order,
		ProblemImageNames:  input.ProblemImageNames,
		SolutionImageNames: input.SolutionImageNames,
		References:         input.References,
		CreatedAt:          currentQuestion.CreatedAt,
	}
	currentTime := time.Now()
	question.SetUpdatedAt(currentTime)

	err = q.AWS.UpdateQuestion(question)
	if err != nil {
		return err
	}
	return nil
}

func (q *Question) DeleteQuestion(input input.DeleteQuestion) error {
	err := q.AWS.DeleteQuestion(input.ID)
	if err != nil {
		return err
	}
	return nil
}
