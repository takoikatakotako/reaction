variable "project" {
  type        = string
  description = "リソース名のプレフィックスに使うプロジェクト名"
  default     = "reaction"
}

variable "environment" {
  type        = string
  description = "環境名 (development / production)"
}

variable "lambda_function_name" {
  type        = string
  description = "監視対象の API Lambda の関数名"
}

variable "lambda_log_group_name" {
  type        = string
  description = "監視対象の API Lambda のロググループ名。ERROR ログの購読に使う"
}

variable "dynamodb_table_names" {
  type        = list(string)
  description = "スロットリングを監視する DynamoDB テーブル名"
}

variable "lambda_duration_p99_threshold_ms" {
  type        = number
  description = "API Lambda の p99 レイテンシのしきい値 (ミリ秒)"
  default     = 10000
}

variable "slack_webhook_ssm_parameter_name" {
  type        = string
  description = "Slack Incoming Webhook URL を格納する SSM パラメータ名"
}

variable "notifier_log_retention_in_days" {
  type        = number
  description = "Slack 通知 Lambda 自身のログ保持日数"
  default     = 30
}
