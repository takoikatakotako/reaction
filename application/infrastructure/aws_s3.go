package infrastructure

import (
	"bytes"
	"context"
	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/s3"
	"time"
)

// Private Methods
func (a *AWS) createS3Client() (*s3.Client, error) {
	// Localの場合
	if a.Profile == "local" {
		// AWS Configを読み込み（LocalStack用にカスタム）
		// CI設定次第移行する
		customResolver := aws.EndpointResolverWithOptionsFunc(func(service, region string, options ...interface{}) (aws.Endpoint, error) {
			return aws.Endpoint{
				URL:               LocalstackEndpoint,
				HostnameImmutable: true,
			}, nil
		})

		cfg, err := config.LoadDefaultConfig(context.TODO(),
			config.WithRegion("ap-northeast-1"),
			config.WithEndpointResolverWithOptions(customResolver),
		)
		if err != nil {
			return nil, err
		}

		return s3.NewFromConfig(cfg), nil
	}

	// Local 以外の場合
	cfg, err := a.createAWSConfig()
	if err != nil {
		return nil, err
	}

	return s3.NewFromConfig(cfg), nil
}

func (a *AWS) GeneratePresignedURL(bucketName string, objectKey string) (string, error) {
	client, err := a.createS3Client()
	if err != nil {
		return "", err
	}

	presign := s3.NewPresignClient(client)
	resp, err := presign.PresignPutObject(context.TODO(), &s3.PutObjectInput{
		Bucket: aws.String(bucketName),
		Key:    aws.String(objectKey),
	}, s3.WithPresignExpires(15*time.Minute)) // 有効期限15分
	if err != nil {
		return "", err
	}

	return resp.URL, nil
}

func (a *AWS) PutObject(bucketName string, objectKey string, data []byte, contentType string) error {
	client, err := a.createS3Client()
	if err != nil {
		return err
	}

	input := &s3.PutObjectInput{
		Bucket:        aws.String(bucketName),
		Key:           aws.String(objectKey),
		Body:          bytes.NewReader(data),
		ContentType:   aws.String(contentType),
		ContentLength: aws.Int64(int64(len(data))),
	}

	_, err = client.PutObject(context.TODO(), input)
	if err != nil {
		return err
	}

	return nil
}
