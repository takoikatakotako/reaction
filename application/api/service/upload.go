package service

import (
	"github.com/takoikatakotako/reaction/api/service/input"
	"github.com/takoikatakotako/reaction/api/service/output"
	"github.com/takoikatakotako/reaction/infrastructure"
)

type Upload struct {
	AWS                infrastructure.AWS
	ResourceBucketName string
}

func (a *Upload) GenerateUploadURLPost(in input.GenerateUploadURL) (output.UploadURL, error) {
	url, err := a.AWS.GeneratePresignedURL(a.ResourceBucketName, in.ImageName)
	if err != nil {
		return output.UploadURL{}, nil
	}

	return output.UploadURL{
		UploadURL: url,
	}, nil
}
