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

func (a *AWS) GetReaction(id string) (database.Reaction, error) {
	client, err := a.createDynamoDBClient()
	if err != nil {
		return database.Reaction{}, err
	}

	// クエリ実行
	input := &dynamodb.GetItemInput{
		TableName: aws.String(database.ReactionTableName),
		Key: map[string]types.AttributeValue{
			"id": &types.AttributeValueMemberS{Value: id},
		},
	}

	// データ取得
	output, err := client.GetItem(context.Background(), input)
	if err != nil {
		return database.Reaction{}, err
	}

	// 取得結果を確認
	if output.Item == nil {
		return database.Reaction{}, errors.New("not found")
	}

	reaction := database.Reaction{}
	err = attributevalue.UnmarshalMap(output.Item, &reaction)
	if err != nil {
		return database.Reaction{}, err
	}
	return reaction, nil
}

func (a *AWS) GetReactions() ([]database.Reaction, error) {
	client, err := a.createDynamoDBClient()
	if err != nil {
		return []database.Reaction{}, err
	}

	// クエリ実行
	input := &dynamodb.ScanInput{
		TableName: aws.String(database.ReactionTableName),
		Limit:     aws.Int32(10),
	}
	output, err := client.Scan(context.Background(), input)
	if err != nil {
		return []database.Reaction{}, err
	}

	// 取得結果を struct の配列に変換
	reactions := make([]database.Reaction, 0)
	for _, item := range output.Items {
		reaction := database.Reaction{}
		err := attributevalue.UnmarshalMap(item, &reaction)
		if err != nil {
			// Error
			pc, fileName, _, _ := runtime.Caller(1)
			funcName := runtime.FuncForPC(pc).Name()
			slog.Error(err.Error(), slog.String("file", fileName), slog.String("func", funcName))
			continue
		}
		reactions = append(reactions, reaction)
	}
	return reactions, nil
}

func (a *AWS) InsertReaction(reaction database.Reaction) error {
	// Alarm のバリデーション
	err := reaction.Validate()
	if err != nil {
		return err
	}

	client, err := a.createDynamoDBClient()
	if err != nil {
		fmt.Printf("err, %v", err)
		return err
	}

	// 新規レコードの追加
	av, err := attributevalue.MarshalMap(reaction)
	if err != nil {
		fmt.Printf("dynamodb marshal: %s\n", err.Error())
		return err
	}
	_, err = client.PutItem(context.Background(), &dynamodb.PutItemInput{
		TableName: aws.String(database.ReactionTableName),
		Item:      av,
	})
	if err != nil {
		fmt.Printf("put item: %s\n", err.Error())
		return err
	}
	return nil
}

func (a *AWS) UpdateReaction(reaction database.Reaction) error {
	// Alarm のバリデーション
	err := reaction.Validate()
	if err != nil {
		return err
	}

	// レコードを更新する
	client, err := a.createDynamoDBClient()
	if err != nil {
		return err
	}

	av, err := attributevalue.MarshalMap(reaction)
	if err != nil {
		return err
	}
	_, err = client.PutItem(context.Background(), &dynamodb.PutItemInput{
		TableName: aws.String(database.ReactionTableName),
		Item:      av,
	})
	if err != nil {
		return err
	}

	return nil
}

func (a *AWS) DeleteReaction(id string) error {
	ctx := context.Background()

	client, err := a.createDynamoDBClient()
	if err != nil {
		return err
	}

	deleteInput := &dynamodb.DeleteItemInput{
		TableName: aws.String(database.ReactionTableName),
		Key: map[string]types.AttributeValue{
			database.ReactionTableID: &types.AttributeValueMemberS{Value: id},
		},
	}

	_, err = client.DeleteItem(ctx, deleteInput)
	if err != nil {
		return err
	}

	return nil
}
