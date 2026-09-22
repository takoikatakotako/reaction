# monitoring モジュール

CloudWatch アラームと ERROR ログを Slack に通知する。

## 構成

```
CloudWatch Alarm ──> SNS ──┐
                           ├──> slack_notifier (Lambda) ──> Slack Incoming Webhook
CloudWatch Logs ───────────┘
  (subscription filter)
```

## 監視対象

| 対象 | メトリクス | 条件 |
|---|---|---|
| API Lambda | `Errors` | 5 分で 1 件以上 |
| API Lambda | `Throttles` | 5 分で 1 件以上 |
| API Lambda | `Duration` (p99) | しきい値超過が 2 回連続 |
| DynamoDB 各テーブル | `ReadThrottleEvents` | 5 分で 1 件以上 |
| DynamoDB 各テーブル | `WriteThrottleEvents` | 5 分で 1 件以上 |
| API のログ | `{ $.level = "ERROR" }` | 該当ログを直接転送 |

## セットアップ

Slack Webhook URL は Terraform では管理しない（シークレットのため）。apply 後に一度だけ手動で投入する。

```bash
aws ssm put-parameter --profile reaction-development --overwrite \
  --name /reaction/development/slack-alert-webhook-url \
  --type SecureString \
  --value 'https://hooks.slack.com/services/...'
```

本番も同様に `reaction-production` / `/reaction/production/...` で投入する。

SSM パラメータ自体は Terraform が `PLACEHOLDER` という値で作成し、以降は `lifecycle.ignore_changes` で値を無視するため、手動投入した値が上書きされることはない。

## 備考

- Slack 通知 Lambda は rikako (takoikatakotako/rikako) の同名 Lambda をベースにしている
- Webhook URL は Lambda 環境変数に `ssm:<パラメータ名>` という参照だけを入れ、起動時に SSM から取得する。実値を環境変数に置くと `update-function-code` のレスポンス経由でログに露出するため
- CloudFront のメトリクスは us-east-1 にしか存在せず、アラームと SNS トピックを別リージョンに作る必要があるため本モジュールには含めていない
