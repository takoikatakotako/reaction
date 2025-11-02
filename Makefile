.PHONY: deploy-resources
deploy-resources:
	aws s3 sync ./checker/resource/  s3://chemist.swiswiswift.com/resource/ --exact-timestamps --delete --profile chemist  
	aws cloudfront create-invalidation --distribution-id E7K0W7JYJMRK --paths "/resource/*" --profile chemist


reaction-admin
