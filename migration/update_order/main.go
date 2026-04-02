package main

import (
	"context"
	"fmt"
	"log"
	"sort"
	"time"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/feature/dynamodb/attributevalue"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb/types"
)

const (
	profile   = "reaction-development"
	tableName = "questions"
)

type Question struct {
	ID                 string   `dynamodbav:"id"`
	Order              int      `dynamodbav:"order"`
	ProblemImageNames  []string `dynamodbav:"problemImageNames"`
	SolutionImageNames []string `dynamodbav:"solutionImageNames"`
	References         []string `dynamodbav:"references"`
	CreatedAt          string   `dynamodbav:"createdAt"`
	UpdatedAt          string   `dynamodbav:"updatedAt"`
}

func main() {
	ctx := context.Background()
	cfg, err := config.LoadDefaultConfig(ctx, config.WithSharedConfigProfile(profile))
	if err != nil {
		log.Fatalf("AWS設定の読み込みに失敗: %v", err)
	}

	client := dynamodb.NewFromConfig(cfg)

	// Scan all questions
	var questions []Question
	var lastKey map[string]types.AttributeValue

	for {
		input := &dynamodb.ScanInput{
			TableName: aws.String(tableName),
		}
		if lastKey != nil {
			input.ExclusiveStartKey = lastKey
		}

		result, err := client.Scan(ctx, input)
		if err != nil {
			log.Fatalf("Scanに失敗: %v", err)
		}

		var batch []Question
		err = attributevalue.UnmarshalListOfMaps(result.Items, &batch)
		if err != nil {
			log.Fatalf("Unmarshalに失敗: %v", err)
		}
		questions = append(questions, batch...)

		if result.LastEvaluatedKey == nil {
			break
		}
		lastKey = result.LastEvaluatedKey
	}

	fmt.Printf("取得した問題数: %d\n", len(questions))

	// Sort by CreatedAt to assign order based on creation time
	sort.Slice(questions, func(i, j int) bool {
		return questions[i].CreatedAt < questions[j].CreatedAt
	})

	// Update each question with order 1..N
	for i, q := range questions {
		order := i + 1
		fmt.Printf("Question %s → order %d\n", q.ID, order)

		av, err := attributevalue.MarshalMap(Question{
			ID:                 q.ID,
			Order:              order,
			ProblemImageNames:  q.ProblemImageNames,
			SolutionImageNames: q.SolutionImageNames,
			References:         q.References,
			CreatedAt:          q.CreatedAt,
			UpdatedAt:          q.UpdatedAt,
		})
		if err != nil {
			log.Fatalf("Marshalに失敗: %v", err)
		}

		_, err = client.PutItem(ctx, &dynamodb.PutItemInput{
			TableName: aws.String(tableName),
			Item:      av,
		})
		if err != nil {
			log.Fatalf("PutItemに失敗 (id=%s): %v", q.ID, err)
		}

		time.Sleep(1200 * time.Millisecond)
	}

	fmt.Println("全問題のorder更新が完了しました！")
}
