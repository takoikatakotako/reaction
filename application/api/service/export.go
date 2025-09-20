package service

import (
	"encoding/json"
	"github.com/takoikatakotako/reaction/infrastructure"
)

type Export struct {
	AWS                infrastructure.AWS
	ResourceBucketName string
}

func (e *Export) ExportReactionsToS3() error {
	reactions, err := e.AWS.GetReactions()
	if err != nil {
		return err
	}

	bytes, err := json.Marshal(reactions)
	if err != nil {
		return err
	}

	objectKey := "reactions.json"
	err = e.AWS.PutObject(e.ResourceBucketName, objectKey, bytes, "application/json")
	if err != nil {
		return err
	}

	return nil
}
