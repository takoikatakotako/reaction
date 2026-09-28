output "bucket_name" {
  description = "デプロイ先の S3 バケット名。"
  value       = aws_s3_bucket.lp.id
}

output "distribution_id" {
  description = "キャッシュ削除に使う CloudFront のディストリビューション ID。"
  value       = aws_cloudfront_distribution.lp.id
}

output "distribution_domain_name" {
  description = "Cloudflare の CNAME に設定する CloudFront のドメイン。"
  value       = aws_cloudfront_distribution.lp.domain_name
}
