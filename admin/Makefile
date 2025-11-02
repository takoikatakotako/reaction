DEVELOPMENT_NEXT_PUBLIC_API_BASE_URL := https://admin.reaction-development.swiswiswift.com
DEVELOPMENT_NEXT_PUBLIC_RESOURCE_BASE_URL := https://reaction-development.swiswiswift.com/resource/image

PRODUCTION_NEXT_PUBLIC_API_BASE_URL := https://admin.reaction-production.swiswiswift.com
PRODUCTION_NEXT_PUBLIC_RESOURCE_BASE_URL := https://reaction-production.swiswiswift.com/resource/image

.PHONY: build-development
build-development:
	pnpm install
	NEXT_PUBLIC_API_KEY=$(DEVELOPMENT_NEXT_PUBLIC_API_KEY) \
	NEXT_PUBLIC_API_BASE_URL=$(DEVELOPMENT_NEXT_PUBLIC_API_BASE_URL) \
	NEXT_PUBLIC_RESOURCE_BASE_URL=$(DEVELOPMENT_NEXT_PUBLIC_RESOURCE_BASE_URL) \
	pnpm build

.PHONY: deploy-development
deploy-development:
	aws s3 sync ./out/ s3://admin.reaction-development.swiswiswift.com --exact-timestamps --delete --profile reaction-development  
	aws cloudfront create-invalidation --distribution-id E20221GYUASSFI --paths "/*" --profile reaction-development

.PHONY: build-production
build-production:
	pnpm install
	NEXT_PUBLIC_API_KEY=$(PRODUCTION_NEXT_PUBLIC_API_KEY) \
	NEXT_PUBLIC_API_BASE_URL=$(PRODUCTION_NEXT_PUBLIC_API_BASE_URL) \
	NEXT_PUBLIC_RESOURCE_BASE_URL=$(PRODUCTION_NEXT_PUBLIC_RESOURCE_BASE_URL) \
	pnpm build

.PHONY: deploy-production
deploy-production:
	aws s3 sync ./out/ s3://admin.reaction-production.swiswiswift.com --exact-timestamps --delete --profile reaction-production  
	aws cloudfront create-invalidation --distribution-id E3AOD193EW8R9B --paths "/*" --profile reaction-production
