package infrastructure

import (
	"context"
	"errors"
	"fmt"
	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/feature/dynamodb/attributevalue"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb/types"
	"github.com/takoikatakotako/reaction/infrastructure/database"
	"log/slog"
	"runtime"
)

func (a *AWS) GetQuestion(id string) (database.Question, error) {
	client, err := a.createDynamoDBClient()
	if err != nil {
		return database.Question{}, err
	}

	input := &dynamodb.GetItemInput{
		TableName: aws.String(database.QuestionTableName),
		Key: map[string]types.AttributeValue{
			"id": &types.AttributeValueMemberS{Value: id},
		},
	}

	output, err := client.GetItem(context.Background(), input)
	if err != nil {
		return database.Question{}, err
	}

	if output.Item == nil {
		return database.Question{}, errors.New("not found")
	}

	question := database.Question{}
	err = attributevalue.UnmarshalMap(output.Item, &question)
	if err != nil {
		return database.Question{}, err
	}
	return question, nil
}

func (a *AWS) GetQuestions() ([]database.Question, error) {
	client, err := a.createDynamoDBClient()
	if err != nil {
		return []database.Question{}, err
	}

	questions := make([]database.Question, 0)
	var lastEvaluatedKey map[string]types.AttributeValue
	for {
		input := &dynamodb.ScanInput{
			TableName:         aws.String(database.QuestionTableName),
			ExclusiveStartKey: lastEvaluatedKey,
		}

		output, err := client.Scan(context.Background(), input)
		if err != nil {
			return nil, err
		}

		for _, item := range output.Items {
			var question database.Question
			err := attributevalue.UnmarshalMap(item, &question)
			if err != nil {
				pc, fileName, _, _ := runtime.Caller(1)
				funcName := runtime.FuncForPC(pc).Name()
				slog.Error(err.Error(), slog.String("file", fileName), slog.String("func", funcName))
				continue
			}
			questions = append(questions, question)
		}

		if output.LastEvaluatedKey == nil || len(output.LastEvaluatedKey) == 0 {
			break
		}
		lastEvaluatedKey = output.LastEvaluatedKey
	}

	return questions, nil
}

func (a *AWS) InsertQuestion(question database.Question) error {
	err := question.Validate()
	if err != nil {
		return err
	}

	client, err := a.createDynamoDBClient()
	if err != nil {
		fmt.Printf("err, %v", err)
		return err
	}

	av, err := attributevalue.MarshalMap(question)
	if err != nil {
		fmt.Printf("dynamodb marshal: %s\n", err.Error())
		return err
	}
	_, err = client.PutItem(context.Background(), &dynamodb.PutItemInput{
		TableName: aws.String(database.QuestionTableName),
		Item:      av,
	})
	if err != nil {
		fmt.Printf("put item: %s\n", err.Error())
		return err
	}
	return nil
}

func (a *AWS) UpdateQuestion(question database.Question) error {
	err := question.Validate()
	if err != nil {
		return err
	}

	client, err := a.createDynamoDBClient()
	if err != nil {
		return err
	}

	av, err := attributevalue.MarshalMap(question)
	if err != nil {
		return err
	}
	_, err = client.PutItem(context.Background(), &dynamodb.PutItemInput{
		TableName: aws.String(database.QuestionTableName),
		Item:      av,
	})
	if err != nil {
		return err
	}

	return nil
}

func (a *AWS) DeleteQuestion(id string) error {
	ctx := context.Background()

	client, err := a.createDynamoDBClient()
	if err != nil {
		return err
	}

	deleteInput := &dynamodb.DeleteItemInput{
		TableName: aws.String(database.QuestionTableName),
		Key: map[string]types.AttributeValue{
			database.QuestionTableID: &types.AttributeValueMemberS{Value: id},
		},
	}

	_, err = client.DeleteItem(ctx, deleteInput)
	if err != nil {
		return err
	}

	return nil
}
