package infrastructure

import (
	"bytes"
	"context"
	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/service/s3"
	"time"
)

// ローカル開発では MinIO を使う（LocalStack の代替、#137）
const LocalS3Endpoint = "http://localhost:9000"

// Private Methods
func (a *AWS) createS3Client() (*s3.Client, error) {
	// Localの場合は MinIO を使う（LocalStack の代替、#137）
	if a.Profile == "local" {
		cfg, err := a.createAWSConfig()
		if err != nil {
			return nil, err
		}

		return s3.NewFromConfig(cfg, func(o *s3.Options) {
			o.BaseEndpoint = aws.String(LocalS3Endpoint)
			// MinIO は仮想ホスト形式のバケット名を解決できないのでパス形式にする
			o.UsePathStyle = true
		}), nil
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
