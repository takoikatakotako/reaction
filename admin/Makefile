NEXT_PUBLIC_API_BASE_URL := https://admin.reaction-development.swiswiswift.com
NEXT_PUBLIC_RESOURCE_BASE_URL := https://reaction-development.swiswiswift.com/resource/image

.PHONY: build-development
build-development:
	pnpm install
	NEXT_PUBLIC_API_BASE_URL=$(NEXT_PUBLIC_API_BASE_URL) \
	NEXT_PUBLIC_RESOURCE_BASE_URL=$(NEXT_PUBLIC_RESOURCE_BASE_URL) \
	pnpm build

.PHONY: deploy-development
deploy-development:
	aws s3 sync ./out/ s3://admin.reaction-development.swiswiswift.com --exact-timestamps --delete --profile reaction-development  
	aws cloudfront create-invalidation --distribution-id E20221GYUASSFI --paths "/*" --profile reaction-development
