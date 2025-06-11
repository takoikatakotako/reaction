package service

import (
	"github.com/google/uuid"
	"github.com/stretchr/testify/assert"
	"github.com/takoikatakotako/reaction/api/service/input"
	"github.com/takoikatakotako/reaction/infrastructure"
	"strings"
	"testing"
)

func TestUpload_GenerateUploadURLPost(t *testing.T) {
	// infrastructure
	awsRepository := infrastructure.AWS{
		Profile: "local",
	}

	// service
	uploadService := Upload{
		AWS:                awsRepository,
		ResourceBucketName: "resource.reaction-local.swiswiswift.com",
	}

	in := input.GenerateUploadURL{
		ImageName: uuid.NewString() + ".png",
	}

	out, err := uploadService.GenerateUploadURLPost(in)
	if err != nil {
		t.Errorf("unexpected error: %v", err)
	}

	expectedPrefix := "http://resource.reaction-local.swiswiswift.com.localhost:4566/"
	assert.True(t, strings.HasPrefix(out.UploadURL, expectedPrefix))
}
