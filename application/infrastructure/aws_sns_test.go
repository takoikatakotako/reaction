package infrastructure

import (
	"context"
	"errors"
	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/sns"
	"github.com/google/uuid"
	"github.com/stretchr/testify/assert"
	"github.com/takoikatakotako/reaction/infrastructure/notification"
	"strings"
	"testing"
)

func TestCreateVoipPlatformEndpoint(t *testing.T) {
	repository := AWS{Profile: "local"}

	token := uuid.New().String()
	endpointArn, err := repository.CreateIOSVoipPushPlatformEndpoint(token)
	if err != nil {
		t.Errorf("unexpected error: %v", err)
	}

	assert.NotEqual(t, len(endpointArn), 0)
}

// エンドポイントを作成してPublishにする
func TestPublishPlatformApplication(t *testing.T) {
	repository := AWS{Profile: "local"}

	// endpointを作成
	token := uuid.New().String()
	endpointArn, err := createEndpoint(token)
	if err != nil {
		t.Errorf("unexpected error: %v", err)
	}

	// 詰め替える
	iOSVoIPPushSNSMessage := notification.IOSVoIPPushSNSMessage{}
	iOSVoIPPushSNSMessage.CharaName = "キャラ名"
	iOSVoIPPushSNSMessage.VoiceFileURL = "ファイルPath"

	err = repository.PublishPlatformApplication(endpointArn, iOSVoIPPushSNSMessage)
	if err != nil {
		t.Errorf("unexpected error: %v", err)
	}
}

func createEndpoint(pushToken string) (endpointArn string, err error) {
	// SQSClient作成
	cfg, err := config.LoadDefaultConfig(context.Background(), config.WithRegion("ap-northeast-1"))
	if err != nil {
		return "", err
	}
	client := sns.NewFromConfig(cfg, func(o *sns.Options) {
		o.BaseEndpoint = aws.String(LocalstackEndpoint)
	})

	// PlatformApplication を取得
	input := &sns.ListPlatformApplicationsInput{}
	output, err := client.ListPlatformApplications(context.Background(), input)
	if err != nil {
		return "", err
	}

	platformApplicationArn := ""
	for _, platformApplication := range output.PlatformApplications {
		if strings.Contains(*platformApplication.PlatformApplicationArn, iOSVoIPPushPlatformApplication) {
			platformApplicationArn = *platformApplication.PlatformApplicationArn
		}
	}

	if platformApplicationArn == "" {
		return "", errors.New("xxx")
	}

	// エンドポイント作成
	getInput := &sns.CreatePlatformEndpointInput{
		PlatformApplicationArn: aws.String(platformApplicationArn),
		Token:                  aws.String(pushToken),
	}
	result, err := client.CreatePlatformEndpoint(context.Background(), getInput)
	if err != nil {
		return "", err
	}

	return *result.EndpointArn, nil
}
