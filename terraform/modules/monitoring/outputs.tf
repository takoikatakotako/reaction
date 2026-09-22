output "sns_topic_arn" {
  description = "アラート通知用 SNS トピックの ARN"
  value       = aws_sns_topic.alerts.arn
}

output "slack_webhook_ssm_parameter_name" {
  description = "Slack Webhook URL を入れる SSM パラメータ名"
  value       = aws_ssm_parameter.slack_webhook_url.name
}
