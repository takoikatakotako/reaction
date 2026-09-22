terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = ">= 2.4.0"
    }
  }
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  name_prefix = "${var.project}-${var.environment}"

  tags = {
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
  }

  alarm_actions = [aws_sns_topic.alerts.arn]
}


##############################################################
# Slack Webhook URL (SSM)
##############################################################
# 値は Terraform では管理しない（シークレットのため）。
# 初回のみ手動で投入する:
#   aws ssm put-parameter --profile reaction-<env> --overwrite \
#     --name <このパラメータ名> --type SecureString \
#     --value 'https://hooks.slack.com/services/...'
resource "aws_ssm_parameter" "slack_webhook_url" {
  name        = var.slack_webhook_ssm_parameter_name
  type        = "SecureString"
  value       = "PLACEHOLDER"
  description = "Slack incoming webhook for CloudWatch alarms (value managed out-of-band)"
  tags        = local.tags

  lifecycle {
    ignore_changes = [value]
  }
}


##############################################################
# SNS
##############################################################
resource "aws_sns_topic" "alerts" {
  name = "${local.name_prefix}-alerts"
  tags = local.tags
}

resource "aws_sns_topic_subscription" "slack" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.slack_notifier.arn
}


##############################################################
# Slack 通知 Lambda
##############################################################
data "archive_file" "slack_notifier" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/slack_notifier"
  output_path = "${path.module}/lambda/slack_notifier.zip"
}

resource "aws_iam_role" "slack_notifier" {
  name = "${local.name_prefix}-slack-notifier"
  tags = local.tags

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "slack_notifier_logs" {
  role       = aws_iam_role.slack_notifier.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "slack_notifier_ssm" {
  name = "ssm-parameter-read"
  role = aws_iam_role.slack_notifier.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["ssm:GetParameter"]
      Resource = aws_ssm_parameter.slack_webhook_url.arn
    }]
  })
}

resource "aws_cloudwatch_log_group" "slack_notifier" {
  name              = "/aws/lambda/${local.name_prefix}-slack-notifier"
  retention_in_days = var.notifier_log_retention_in_days
  tags              = local.tags
}

resource "aws_lambda_function" "slack_notifier" {
  function_name    = "${local.name_prefix}-slack-notifier"
  role             = aws_iam_role.slack_notifier.arn
  runtime          = "python3.13"
  handler          = "index.handler"
  filename         = data.archive_file.slack_notifier.output_path
  source_code_hash = data.archive_file.slack_notifier.output_base64sha256
  timeout          = 10
  memory_size      = 128
  tags             = local.tags

  environment {
    variables = {
      # 実値ではなく SSM の参照を渡す。Lambda 環境変数に直接書くと
      # update-function-code のレスポンス経由でログに露出するため。
      SLACK_WEBHOOK_URL = "ssm:${aws_ssm_parameter.slack_webhook_url.name}"
    }
  }

  depends_on = [aws_cloudwatch_log_group.slack_notifier]
}

resource "aws_lambda_permission" "allow_sns_invoke" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.slack_notifier.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.alerts.arn
}

resource "aws_lambda_permission" "allow_logs_invoke" {
  statement_id  = "AllowExecutionFromCloudWatchLogs"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.slack_notifier.function_name
  principal     = "logs.amazonaws.com"
  source_arn    = "arn:aws:logs:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:log-group:${var.lambda_log_group_name}:*"
}


##############################################################
# ERROR ログを Slack に転送
##############################################################
# API は slog の JSON ハンドラで出力しているため JSON パスで絞り込める
resource "aws_cloudwatch_log_subscription_filter" "api_error_logs" {
  name            = "${local.name_prefix}-api-error-logs"
  log_group_name  = var.lambda_log_group_name
  filter_pattern  = "{ $.level = \"ERROR\" }"
  destination_arn = aws_lambda_function.slack_notifier.arn
  depends_on      = [aws_lambda_permission.allow_logs_invoke]
}


##############################################################
# CloudWatch Alarms - Lambda
##############################################################
resource "aws_cloudwatch_metric_alarm" "api_errors" {
  alarm_name          = "${local.name_prefix}-api-errors"
  alarm_description   = "API Lambda が 5 分間で 1 件以上エラーを出した"
  namespace           = "AWS/Lambda"
  metric_name         = "Errors"
  statistic           = "Sum"
  period              = 300
  evaluation_periods  = 1
  threshold           = 1
  comparison_operator = "GreaterThanOrEqualToThreshold"
  treat_missing_data  = "notBreaching"
  dimensions          = { FunctionName = var.lambda_function_name }
  alarm_actions       = local.alarm_actions
  ok_actions          = local.alarm_actions
  tags                = local.tags
}

resource "aws_cloudwatch_metric_alarm" "api_throttles" {
  alarm_name          = "${local.name_prefix}-api-throttles"
  alarm_description   = "API Lambda がスロットリングされた"
  namespace           = "AWS/Lambda"
  metric_name         = "Throttles"
  statistic           = "Sum"
  period              = 300
  evaluation_periods  = 1
  threshold           = 1
  comparison_operator = "GreaterThanOrEqualToThreshold"
  treat_missing_data  = "notBreaching"
  dimensions          = { FunctionName = var.lambda_function_name }
  alarm_actions       = local.alarm_actions
  ok_actions          = local.alarm_actions
  tags                = local.tags
}

resource "aws_cloudwatch_metric_alarm" "api_p99_latency" {
  alarm_name          = "${local.name_prefix}-api-p99-latency"
  alarm_description   = "API Lambda の p99 レイテンシがしきい値を超えた"
  namespace           = "AWS/Lambda"
  metric_name         = "Duration"
  extended_statistic  = "p99"
  period              = 300
  evaluation_periods  = 2
  threshold           = var.lambda_duration_p99_threshold_ms
  comparison_operator = "GreaterThanThreshold"
  treat_missing_data  = "notBreaching"
  dimensions          = { FunctionName = var.lambda_function_name }
  alarm_actions       = local.alarm_actions
  ok_actions          = local.alarm_actions
  tags                = local.tags
}


##############################################################
# CloudWatch Alarms - DynamoDB
##############################################################
# テーブルは PROVISIONED / RCU・WCU ともに 1 のため、
# アクセスが増えるとスロットリングしやすい
resource "aws_cloudwatch_metric_alarm" "dynamodb_read_throttle" {
  for_each = toset(var.dynamodb_table_names)

  alarm_name          = "${local.name_prefix}-dynamodb-${each.key}-read-throttle"
  alarm_description   = "DynamoDB テーブル ${each.key} で読み込みスロットリングが発生した"
  namespace           = "AWS/DynamoDB"
  metric_name         = "ReadThrottleEvents"
  statistic           = "Sum"
  period              = 300
  evaluation_periods  = 1
  threshold           = 1
  comparison_operator = "GreaterThanOrEqualToThreshold"
  treat_missing_data  = "notBreaching"
  dimensions          = { TableName = each.key }
  alarm_actions       = local.alarm_actions
  ok_actions          = local.alarm_actions
  tags                = local.tags
}

resource "aws_cloudwatch_metric_alarm" "dynamodb_write_throttle" {
  for_each = toset(var.dynamodb_table_names)

  alarm_name          = "${local.name_prefix}-dynamodb-${each.key}-write-throttle"
  alarm_description   = "DynamoDB テーブル ${each.key} で書き込みスロットリングが発生した"
  namespace           = "AWS/DynamoDB"
  metric_name         = "WriteThrottleEvents"
  statistic           = "Sum"
  period              = 300
  evaluation_periods  = 1
  threshold           = 1
  comparison_operator = "GreaterThanOrEqualToThreshold"
  treat_missing_data  = "notBreaching"
  dimensions          = { TableName = each.key }
  alarm_actions       = local.alarm_actions
  ok_actions          = local.alarm_actions
  tags                = local.tags
}
