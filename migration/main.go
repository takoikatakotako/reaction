package main

import (
	"context"
	"fmt"
	"log"
	"os"
	"time"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/feature/dynamodb/attributevalue"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
	"github.com/aws/aws-sdk-go-v2/service/s3"
	"github.com/google/uuid"
)

const (
	profile    = "reaction-development"
	bucketName = "resource.reaction-development.swiswiswift.com"
	tableName  = "questions"
	assetsBase = "../ios/Reaction/Assets.xcassets/question"
)

type QuestionData struct {
	ID                 int
	ProblemImagePaths  []string // asset catalog内のパス
	SolutionImagePaths []string
	References         []string
}

func main() {
	questions := buildQuestions()

	ctx := context.Background()
	cfg, err := config.LoadDefaultConfig(ctx, config.WithSharedConfigProfile(profile))
	if err != nil {
		log.Fatalf("AWS設定の読み込みに失敗: %v", err)
	}

	s3Client := s3.NewFromConfig(cfg)
	dynamoClient := dynamodb.NewFromConfig(cfg)

	for _, q := range questions {
		fmt.Printf("Question %d Uploading...\n", q.ID)

		// Upload problem images
		problemImageNames := make([]string, 0)
		for _, path := range q.ProblemImagePaths {
			imageName := fmt.Sprintf("%s.png", uuid.NewString())
			err := uploadImage(s3Client, path, imageName)
			if err != nil {
				log.Fatalf("Question %d: problem image upload failed: %v", q.ID, err)
			}
			problemImageNames = append(problemImageNames, imageName)
		}

		// Upload solution images
		solutionImageNames := make([]string, 0)
		for _, path := range q.SolutionImagePaths {
			imageName := fmt.Sprintf("%s.png", uuid.NewString())
			err := uploadImage(s3Client, path, imageName)
			if err != nil {
				log.Fatalf("Question %d: solution image upload failed: %v", q.ID, err)
			}
			solutionImageNames = append(solutionImageNames, imageName)
		}

		// Insert to DynamoDB
		currentTime := time.Now().UTC().Format(time.RFC3339)
		item := map[string]interface{}{
			"id":                 uuid.NewString(),
			"problemImageNames":  problemImageNames,
			"solutionImageNames": solutionImageNames,
			"references":         q.References,
			"createdAt":          currentTime,
			"updatedAt":          currentTime,
		}

		av, err := attributevalue.MarshalMap(item)
		if err != nil {
			log.Fatalf("Question %d: marshal failed: %v", q.ID, err)
		}

		_, err = dynamoClient.PutItem(ctx, &dynamodb.PutItemInput{
			TableName: aws.String(tableName),
			Item:      av,
		})
		if err != nil {
			log.Fatalf("Question %d: DynamoDB insert failed: %v", q.ID, err)
		}

		fmt.Printf("Question %d Done!\n", q.ID)
	}

	fmt.Println("Migration Finish!!")
}

func uploadImage(client *s3.Client, filePath string, imageName string) error {
	file, err := os.Open(filePath)
	if err != nil {
		return fmt.Errorf("ファイルを開けませんでした: %v", err)
	}
	defer file.Close()

	key := fmt.Sprintf("resource/image/%s", imageName)
	_, err = client.PutObject(context.TODO(), &s3.PutObjectInput{
		Bucket:      aws.String(bucketName),
		Key:         aws.String(key),
		Body:        file,
		ContentType: aws.String("image/png"),
	})
	return err
}

// findImageFile はasset catalog内の画像ファイルパスを返す
func findImageFile(imagesetDir string) string {
	entries, err := os.ReadDir(imagesetDir)
	if err != nil {
		log.Fatalf("ディレクトリを読めませんでした: %s: %v", imagesetDir, err)
	}
	for _, entry := range entries {
		if entry.Name() != "Contents.json" && !entry.IsDir() {
			return fmt.Sprintf("%s/%s", imagesetDir, entry.Name())
		}
	}
	log.Fatalf("画像ファイルが見つかりません: %s", imagesetDir)
	return ""
}

func problemPath(n int) string {
	return findImageFile(fmt.Sprintf("%s/question-problem-%d.imageset", assetsBase, n))
}

func solutionPath(n int) string {
	return findImageFile(fmt.Sprintf("%s/question-solution-%d.imageset", assetsBase, n))
}

func solutionImagePath(n int, img int) string {
	return findImageFile(fmt.Sprintf("%s/question-solution-%d-image-%d.imageset", assetsBase, n, img))
}

func buildQuestions() []QuestionData {
	questions := make([]QuestionData, 0, 100)

	// Question 1-10: single problem, single solution, with references
	refs := map[int][]string{
		1:  {"https://pubs.acs.org/doi/10.1021/ol9025793"},
		2:  {"https://www.degruyter.com/document/doi/10.1351/pac196817030519/html"},
		3:  {"https://doi.org/10.1021/ja01183a084"},
		4:  {"https://pubs.acs.org/doi/10.1021/ja9103233", "https://cdnsciencepub.com/doi/abs/10.1139/v78-048"},
		5:  {"https://doi.org/10.1016/S0040-4039(00)61908-1"},
		6:  {"https://doi.org/10.1021/ja00844a065"},
		7:  {"https://doi.org/10.1002/anie.201102494"},
		8:  {"https://doi.org/10.1021/ol9001653"},
		9:  {"https://doi.org/10.1021/op010041v"},
		10: {"https://doi.org/10.1002/jlac.19576060109"},
		11: {"https://doi.org/10.1021/ol5028249"},
		12: {"https://doi.org/10.1021/ja9029736"},
		13: {"https://doi.org/10.1016/j.tetlet.2010.11.100"},
		14: {"https://doi.org/10.1002/chem.201701438"},
		15: {"https://doi.org/10.1021/ol061137i"},
		16: {"https://doi.org/10.1016/j.tetlet.2006.05.028"},
		17: {"https://doi.org/10.1021/acs.orglett.1c03319"},
		18: {"https://doi.org/10.1021/jo00072a035", "https://doi.org/10.1021/jo00357a035"},
		19: {"https://doi.org/10.1002/anie.200804883"},
		20: {"https://doi.org/10.1021/acs.joc.6b02102"},
	}

	for i := 1; i <= 100; i++ {
		q := QuestionData{
			ID:                i,
			ProblemImagePaths: []string{problemPath(i)},
			References:        refs[i], // nilの場合は空スライスにする
		}
		if q.References == nil {
			q.References = []string{}
		}

		// 複数解答画像のケース
		switch i {
		case 66:
			q.SolutionImagePaths = []string{
				solutionImagePath(66, 1),
				solutionImagePath(66, 2),
			}
		case 80:
			q.SolutionImagePaths = []string{
				solutionImagePath(80, 1),
				solutionImagePath(80, 2),
			}
		case 89:
			q.SolutionImagePaths = []string{
				solutionImagePath(89, 1),
				solutionImagePath(89, 2),
				solutionImagePath(89, 3),
				solutionImagePath(89, 4),
			}
		default:
			q.SolutionImagePaths = []string{solutionPath(i)}
		}

		questions = append(questions, q)
	}

	return questions
}
