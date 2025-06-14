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
}
