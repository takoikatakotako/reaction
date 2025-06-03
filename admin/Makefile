
.PHONY: build-development
build-development:
	pnpm install
	pnpm build

.PHONY: deploy-development
deploy-development:
	aws s3 sync ./out/ s3://admin.reaction-development.swiswiswift.com --exact-timestamps --delete --profile reaction-development  
	# aws cloudfront create-invalidation --distribution-id E7K0W7JYJMRK --paths "/resource/*" --profile reaction-development
