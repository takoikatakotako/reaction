package infrastructure

import (
	"context"
	"fmt"
	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/service/cloudfront"
	"github.com/aws/aws-sdk-go-v2/service/cloudfront/types"
	"time"
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
	client, err := a.createCloudfrontClient()
	if err != nil {
		return err
	}

	// キャッシュ無効化リクエストの作成
	callerReference := fmt.Sprintf("invalidation-%d", time.Now().Unix())
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
