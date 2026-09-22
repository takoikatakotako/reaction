output "sns_topic_arn" {
  description = "アラート通知用 SNS トピックの ARN"
  value       = aws_sns_topic.alerts.arn
}

output "slack_webhook_ssm_parameter_name" {
  description = "Slack Webhook URL を入れる SSM パラメータ名（Terraform 管理外。手動で作成する）"
  value       = var.slack_webhook_ssm_parameter_name
}
