package infrastructure

import (
	"context"
	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/service/s3"
	"time"
)

// Private Methods
func (a *AWS) createS3Client() (*s3.Client, error) {
	cfg, err := a.createAWSConfig()
	if err != nil {
		return nil, err
	}

	// Localの場合
	if a.Profile == "local" {
		return s3.NewFromConfig(cfg, func(o *s3.Options) {
			o.BaseEndpoint = aws.String(LocalstackEndpoint)
		}), nil
	}

	// Local 以外の場合
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

func (a *AWS) PutObject(bucketName string, objectKey string, xxx []byte) (string, error) {
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
