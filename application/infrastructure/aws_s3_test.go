package infrastructure

import (
	"fmt"
	"github.com/google/uuid"
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestAWS_GeneratePresignedURL(t *testing.T) {
	// Infrastructure
	infra := AWS{Profile: "local"}

	bucketName := "resource.reaction-local.swiswiswift.com"
	url, err := infra.GeneratePresignedURL(bucketName, "takoikatakotako.png")
	assert.NoError(t, err)
	assert.NotEqual(t, 0, len(url))
}

func TestAWS_PutObject(t *testing.T) {
	// Infrastructure
	infra := AWS{Profile: "local"}

	bucketName := "resource.reaction-local.swiswiswift.com"
	objectKey := fmt.Sprintf("%s.json", uuid.NewString())
	content := []byte("{}")
	contentType := "application/json"

	// PutObject 実行
	err := infra.PutObject(bucketName, objectKey, content, contentType)
	assert.NoError(t, err)

	//// オブジェクトを取得して内容を検証
	//getResp, err := client.GetObject(context.TODO(), &s3.GetObjectInput{
	//	Bucket: aws.String(bucketName),
	//	Key:    aws.String(objectKey),
	//})
	//assert.NoError(t, err)
	//
	//buf := new(bytes.Buffer)
	//_, err = buf.ReadFrom(getResp.Body)
	//assert.NoError(t, err)
	//assert.Equal(t, string(content), buf.String())
}
