package infrastructure

import (
	"context"
	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/service/cloudfront"
	"github.com/aws/aws-sdk-go-v2/service/cloudfront/types"
	"github.com/google/uuid"
)

// Private Methods
func (a *AWS) createCloudfrontClient() (*cloudfront.Client, error) {
	cfg, err := a.createAWSConfig()
	if err != nil {
		return nil, err
	}
	// LocalStackは使わないので
	return cloudfront.NewFromConfig(cfg), nil
}

func (a *AWS) CreateInvalidation(distributionID string, paths []string) error {
	// ローカル開発では CloudFront を使わないため distribution が無い。
	// 呼び出し側で分岐させず、ここで何もせず成功扱いにする。
	if distributionID == "" {
		return nil
	}

	client, err := a.createCloudfrontClient()
	if err != nil {
		return err
	}

	callerReference := newInvalidationCallerReference()
	input := &cloudfront.CreateInvalidationInput{
		DistributionId: aws.String(distributionID),
		InvalidationBatch: &types.InvalidationBatch{
			CallerReference: &callerReference,
			Paths: &types.Paths{
				Quantity: aws.Int32(int32(len(paths))),
				Items:    paths,
			},
		},
	}

	// 無効化の実行
	_, err = client.CreateInvalidation(context.TODO(), input)
	if err != nil {
		return err
	}
	return nil
}

// CallerReference は distribution ごとに一意である必要がある。
// 秒精度のタイムスタンプだと、1 回のエクスポートで複数回呼ぶ際に
// 同じ秒に収まって InvalidArgument で失敗する。
func newInvalidationCallerReference() string {
	return "invalidation-" + uuid.NewString()
}
