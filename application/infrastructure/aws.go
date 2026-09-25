package infrastructure

import (
	"context"
	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/credentials"
)

// ローカルのモック用の資格情報。
// DynamoDB Local も s3mock も値を検証しないが、SDK は資格情報が
// 無いとリクエストを組み立てられないのでダミーを渡す。
const (
	LocalAccessKeyID     = "reactionlocal"
	LocalSecretAccessKey = "reactionlocal"
)

type AWS struct {
	Profile string
}

// Private Methods
func (a *AWS) createAWSConfig() (aws.Config, error) {
	ctx := context.Background()

	// 本番環境の場合
	if a.Profile == "" {
		cfg, err := config.LoadDefaultConfig(ctx)
		if err != nil {
			return aws.Config{}, err
		}
		return cfg, nil
	}

	// CI やローカル開発で DynamoDB Local / s3mock を利用する場合
	if a.Profile == "local" {
		cfg, err := config.LoadDefaultConfig(ctx,
			config.WithRegion("ap-northeast-1"),
			config.WithCredentialsProvider(credentials.NewStaticCredentialsProvider(
				LocalAccessKeyID, LocalSecretAccessKey, "",
			)),
		)
		if err != nil {
			return aws.Config{}, err
		}
		return cfg, nil
	}

	// プロファイルを利用する場合
	cfg, err := config.LoadDefaultConfig(ctx, config.WithSharedConfigProfile(a.Profile))
	if err != nil {
		return aws.Config{}, err
	}
	return cfg, nil
}
