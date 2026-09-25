package infrastructure

import (
	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
)

// ローカル開発では DynamoDB Local を使う（LocalStack の代替、#137）
const LocalDynamoDBEndpoint = "http://localhost:8000"

// Private Methods
func (a *AWS) createDynamoDBClient() (*dynamodb.Client, error) {
	cfg, err := a.createAWSConfig()
	if err != nil {
		return nil, err
	}

	// Localの場合
	if a.Profile == "local" {
		return dynamodb.NewFromConfig(cfg, func(o *dynamodb.Options) {
			o.BaseEndpoint = aws.String(LocalDynamoDBEndpoint)
		}), nil
	}

	// Local 以外の場合
	return dynamodb.NewFromConfig(cfg), nil
}
