package main

import (
	"context"
	"fmt"
	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/feature/dynamodb/attributevalue"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
	"github.com/aws/aws-sdk-go-v2/service/s3"
	"github.com/google/uuid"
	"github.com/takoikatakotako/reaction/checker/database"
	"log"
	"os"
	"time"
)

func main() {
	// ファイルを読み込み
	reactions := readReactionsFile("resource/reactions.json")
	checkReactions(reactions)

	ctx := context.Background()
	cfg, err := config.LoadDefaultConfig(ctx, config.WithSharedConfigProfile("reaction-development"))
	if err != nil {
		log.Fatal("Failed to ")
	}

	for i, reaction := range reactions {

		limit := 10
		if limit < i {
			break
		}

		fmt.Printf("%s Uploading...\n", reaction.DirectoryName)

		databaseReaction := database.Reaction{}
		databaseReaction.ID = uuid.NewString()
		databaseReaction.EnglishName = reaction.English
		databaseReaction.JapaneseName = reaction.Japanese
		databaseReaction.Suggestions = reaction.Suggestions
		databaseReaction.Reactants = reaction.Reactants
		databaseReaction.Products = reaction.Products
		databaseReaction.YoutubeUrls = reaction.YoutubeLinks

		currentTime := time.Now()
		databaseReaction.SetCreatedAt(currentTime)
		databaseReaction.SetUpdatedAt(currentTime)

		// Thumbnail
		thumbnailImagePath := fmt.Sprintf("resource/images/%s/%s", reaction.DirectoryName, reaction.ThmbnailName)
		thumbnailImageName := fmt.Sprintf("%s.png", uuid.NewString())
		err := uploadImage(cfg, thumbnailImagePath, thumbnailImageName)
		if err != nil {
			log.Fatal("thumbnail Upload Error")
		}
		databaseReaction.ThumbnailImageName = thumbnailImageName

		// GeneralFormulas
		generalFormulaImageNames := make([]string, 0)
		for _, generalFormula := range reaction.GeneralFormulas {
			generalFormulaImagePath := fmt.Sprintf("resource/images/%s/%s", reaction.DirectoryName, generalFormula.ImageName)
			generalFormulaImageName := fmt.Sprintf("%s.png", uuid.NewString())
			err := uploadImage(cfg, generalFormulaImagePath, generalFormulaImageName)
			if err != nil {
				log.Fatal("General Formula Upload Error")
			}
			generalFormulaImageNames = append(generalFormulaImageNames, generalFormulaImageName)
		}
		databaseReaction.GeneralFormulaImageNames = generalFormulaImageNames

		// Mechanisms
		mechanismsImageNames := make([]string, 0)
		for _, mechanism := range reaction.Mechanisms {
			mechanismImagePath := fmt.Sprintf("resource/images/%s/%s", reaction.DirectoryName, mechanism.ImageName)
			mechanismsImageName := fmt.Sprintf("%s.png", uuid.NewString())
			err := uploadImage(cfg, mechanismImagePath, mechanismsImageName)
			if err != nil {
				log.Fatal("General Formula Upload Error")
			}
			mechanismsImageNames = append(mechanismsImageNames, mechanismsImageName)
		}
		databaseReaction.MechanismsImageNames = mechanismsImageNames

		// Examples
		exampleImageNames := make([]string, 0)
		for _, example := range reaction.Examples {
			exampleImagePath := fmt.Sprintf("resource/images/%s/%s", reaction.DirectoryName, example.ImageName)
			exampleImageName := fmt.Sprintf("%s.png", uuid.NewString())
			err := uploadImage(cfg, exampleImagePath, exampleImageName)
			if err != nil {
				log.Fatal("General Formula Upload Error")
			}
			exampleImageNames = append(exampleImageNames, exampleImageName)
		}
		databaseReaction.ExampleImageNames = mechanismsImageNames

		// Supplements
		supplementsImageNames := make([]string, 0)
		for _, supplement := range reaction.Supplements {
			supplementImagePath := fmt.Sprintf("resource/images/%s/%s", reaction.DirectoryName, supplement.ImageName)
			supplementsImageName := fmt.Sprintf("%s.png", uuid.NewString())
			err := uploadImage(cfg, supplementImagePath, supplementsImageName)
			if err != nil {
				log.Fatal("General Formula Upload Error")
			}
			supplementsImageNames = append(supplementsImageNames, supplementsImageName)
		}
		databaseReaction.SupplementsImageNames = supplementsImageNames

		// Insert
		err = insertDatabaseReaction(cfg, databaseReaction)
		if err != nil {
			log.Fatal("General Formula Upload Error")
		}
	}

	fmt.Printf("Finish!!")
}

func uploadImage(cfg aws.Config, filePath string, imageName string) error {
	// Open Image
	file, err := os.Open(filePath)
	if err != nil {
		log.Fatalf("ファイルを開けませんでした: %v", err)
	}
	defer file.Close()

	// Upload
	s3Client := s3.NewFromConfig(cfg)
	_, err = s3Client.PutObject(context.TODO(), &s3.PutObjectInput{
		Bucket:      aws.String("admin-storage.reaction-development.swiswiswift.com"),
		Key:         aws.String(imageName),
		Body:        file,
		ContentType: aws.String("image/png"), // 必要に応じて変更
	})

	if err != nil {
		return err
	}
	return nil
}

func insertDatabaseReaction(cfg aws.Config, databaseReaction database.Reaction) error {
	err := databaseReaction.Validate()
	if err != nil {
		return err
	}

	dynamodbClient := dynamodb.NewFromConfig(cfg)
	av, err := attributevalue.MarshalMap(databaseReaction)
	if err != nil {
		return err
	}
	_, err = dynamodbClient.PutItem(context.Background(), &dynamodb.PutItemInput{
		TableName: aws.String(database.ReactionTableName),
		Item:      av,
	})
	if err != nil {
		return err
	}

	return nil
}

//func convertToDatabaseReaction(reaction Reaction) database.Reaction  {
//	database.Reaction{
//		ID                : uuid.NewString(),
//		EnglishName          : reaction.English,
//		JapaneseName: reaction.Japanese,
//		ThumbnailImageName: reaction.ThmbnailName,
//		GeneralFormulaImageNames []string `dynamodbav:"generalFormulaImageNames"`
//		MechanismsImageNames     []string `dynamodbav:"mechanismsImageNames"`
//		ExampleImageNames        []string `dynamodbav:"exampleImageNames"`
//		SupplementsImageNames    []string `dynamodbav:"supplementsImageNames"`
//		Suggestions              []string `dynamodbav:"suggestions"`
//		Reactants                []string `dynamodbav:"reactants"`
//		Products                 []string `dynamodbav:"products"`
//		YoutubeUrls              []string `dynamodbav:"youtubeUrls"`
//		CreatedAt                string   `dynamodbav:"createdAt"`
//		UpdatedAt                string   `dynamodbav:"updatedAt"`
//	}
//}
