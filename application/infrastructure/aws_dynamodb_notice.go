package infrastructure

import (
	"context"
	"errors"
	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/feature/dynamodb/attributevalue"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb/types"
	"github.com/takoikatakotako/reaction/infrastructure/database"
	"log/slog"
	"runtime"
	"sort"
)

func (a *AWS) GetNotice(id string) (database.Notice, error) {
	client, err := a.createDynamoDBClient()
	if err != nil {
		return database.Notice{}, err
	}

	input := &dynamodb.GetItemInput{
		TableName: aws.String(database.NoticeTableName),
		Key: map[string]types.AttributeValue{
			database.NoticeTableID: &types.AttributeValueMemberS{Value: id},
		},
	}

	output, err := client.GetItem(context.Background(), input)
	if err != nil {
		return database.Notice{}, err
	}

	if output.Item == nil {
		return database.Notice{}, errors.New("not found")
	}

	notice := database.Notice{}
	err = attributevalue.UnmarshalMap(output.Item, &notice)
	if err != nil {
		return database.Notice{}, err
	}
	return notice, nil
}

func (a *AWS) GetNotices() ([]database.Notice, error) {
	client, err := a.createDynamoDBClient()
	if err != nil {
		return []database.Notice{}, err
	}

	notices := make([]database.Notice, 0)
	var lastEvaluatedKey map[string]types.AttributeValue
	for {
		input := &dynamodb.ScanInput{
			TableName:         aws.String(database.NoticeTableName),
			ExclusiveStartKey: lastEvaluatedKey,
		}

		output, err := client.Scan(context.Background(), input)
		if err != nil {
			return nil, err
		}

		for _, item := range output.Items {
			var notice database.Notice
			err := attributevalue.UnmarshalMap(item, &notice)
			if err != nil {
				pc, fileName, _, _ := runtime.Caller(1)
				funcName := runtime.FuncForPC(pc).Name()
				slog.Error(err.Error(), slog.String("file", fileName), slog.String("func", funcName))
				continue
			}
			notices = append(notices, notice)
		}

		if len(output.LastEvaluatedKey) == 0 {
			break
		}
		lastEvaluatedKey = output.LastEvaluatedKey
	}

	// 新しいお知らせが先に来るように PublishedAt の降順で並べる
	sort.Slice(notices, func(i, j int) bool {
		return notices[i].PublishedAt > notices[j].PublishedAt
	})

	return notices, nil
}

func (a *AWS) InsertNotice(notice database.Notice) error {
	return a.putNotice(notice)
}

func (a *AWS) UpdateNotice(notice database.Notice) error {
	return a.putNotice(notice)
}

func (a *AWS) putNotice(notice database.Notice) error {
	if err := notice.Validate(); err != nil {
		return err
	}

	client, err := a.createDynamoDBClient()
	if err != nil {
		return err
	}

	av, err := attributevalue.MarshalMap(notice)
	if err != nil {
		return err
	}

	_, err = client.PutItem(context.Background(), &dynamodb.PutItemInput{
		TableName: aws.String(database.NoticeTableName),
		Item:      av,
	})
	return err
}

func (a *AWS) DeleteNotice(id string) error {
	client, err := a.createDynamoDBClient()
	if err != nil {
		return err
	}

	_, err = client.DeleteItem(context.Background(), &dynamodb.DeleteItemInput{
		TableName: aws.String(database.NoticeTableName),
		Key: map[string]types.AttributeValue{
			database.NoticeTableID: &types.AttributeValueMemberS{Value: id},
		},
	})
	return err
}
