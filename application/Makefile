ADMIN_REPOSITORY_URI = 392961483375.dkr.ecr.ap-northeast-1.amazonaws.com/reaction-admin
GITHUB_SHA ?= local

.PHONY: test
test:
	go clean -testcache
	go test ./...

.PHONY: build-admin-image
build-admin-image:
	aws ecr get-login-password --region ap-northeast-1 --profile reaction-management | docker login --username AWS --password-stdin 392961483375.dkr.ecr.ap-northeast-1.amazonaws.com
	docker buildx create --use --platform linux/arm64
	docker buildx build --platform linux/arm64 -t reaction/admin:latest --load -f api/Dockerfile .
	docker tag reaction/admin:latest ${ADMIN_REPOSITORY_URI}:latest
	docker push ${ADMIN_REPOSITORY_URI}:latest
	docker tag reaction/admin:latest ${ADMIN_REPOSITORY_URI}:${GITHUB_SHA}
	docker push ${ADMIN_REPOSITORY_URI}:${GITHUB_SHA}
