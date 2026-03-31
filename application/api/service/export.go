package service

import (
	"encoding/json"
	"github.com/takoikatakotako/reaction/infrastructure"
	"github.com/takoikatakotako/reaction/infrastructure/file"
)

type Export struct {
	AWS                infrastructure.AWS
	ResourceBucketName string
	ResourceBaseURL    string
	DistributionID     string
}

func (e *Export) ExportReactionsToS3() error {
	reactions, err := e.AWS.GetReactions()
	if err != nil {
		return err
	}

	// Convert to file.Reaction for export
	fileReactions := make([]file.Reaction, 0, len(reactions))
	for _, reaction := range reactions {
		fileReaction := convertToFileReaction(reaction, e.ResourceBaseURL)
		fileReactions = append(fileReactions, fileReaction)
	}

	// データベースで既にソート済み

	// Export reactions list
	fileReactionsWrapper := file.Reactions{Reactions: fileReactions}
	bytes, err := json.Marshal(fileReactionsWrapper)
	if err != nil {
		return err
	}

	objectKey := "resource/reaction/list.json"
	err = e.AWS.PutObject(e.ResourceBucketName, objectKey, bytes, "application/json")
	if err != nil {
		return err
	}

	// Export individual reaction files
	for _, fileReaction := range fileReactions {
		reactionBytes, err := json.Marshal(fileReaction)
		if err != nil {
			return err
		}

		individualKey := "resource/reaction/" + fileReaction.ID + "/reaction.json"
		err = e.AWS.PutObject(e.ResourceBucketName, individualKey, reactionBytes, "application/json")
		if err != nil {
			return err
		}
	}

	// S3エクスポート後、CloudFront distributionのキャッシュを無効化
	paths := []string{"/resource/reaction/*"}
	err = e.AWS.CreateInvalidation(e.DistributionID, paths)
	if err != nil {
		return err
	}
	return nil
}

func (e *Export) ExportQuestionsToS3() error {
	questions, err := e.AWS.GetQuestions()
	if err != nil {
		return err
	}

	fileQuestions := make([]file.Question, 0, len(questions))
	for _, question := range questions {
		fileQuestion := convertToFileQuestion(question, e.ResourceBaseURL)
		fileQuestions = append(fileQuestions, fileQuestion)
	}

	// Export questions list
	fileQuestionsWrapper := file.Questions{Questions: fileQuestions}
	bytes, err := json.Marshal(fileQuestionsWrapper)
	if err != nil {
		return err
	}

	objectKey := "resource/question/list.json"
	err = e.AWS.PutObject(e.ResourceBucketName, objectKey, bytes, "application/json")
	if err != nil {
		return err
	}

	// Export individual question files
	for _, fileQuestion := range fileQuestions {
		questionBytes, err := json.Marshal(fileQuestion)
		if err != nil {
			return err
		}

		individualKey := "resource/question/" + fileQuestion.ID + "/question.json"
		err = e.AWS.PutObject(e.ResourceBucketName, individualKey, questionBytes, "application/json")
		if err != nil {
			return err
		}
	}

	// CloudFrontキャッシュ無効化
	paths := []string{"/resource/question/*"}
	err = e.AWS.CreateInvalidation(e.DistributionID, paths)
	if err != nil {
		return err
	}
	return nil
}
