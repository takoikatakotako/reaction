package infrastructure

import (
	"context"
	"errors"
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
	// ローカル開発では CloudFront が無いのでスキップする。
	// 非 local で ID が空なのは環境変数の設定漏れなので、黙って成功扱いにせず
	// エラーにする（キャッシュが古いまま残るのを見逃さないため）。
	if distributionID == "" {
		if a.Profile == "local" {
			return nil
		}
		return errors.New("distribution id is empty")
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
