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

Slack Webhook URL は Terraform では管理しない。`aws_ssm_parameter` で管理すると、`lifecycle.ignore_changes` を付けていても refresh 時に `GetParameter(WithDecryption=true)` が走り、復号済みの値が state に保存されてしまうため。

**apply の前に**一度だけ手動で作成する。

```bash
aws ssm put-parameter --profile reaction-development \
  --name /reaction/development/slack-alert-webhook-url \
  --type SecureString \
  --value 'https://hooks.slack.com/services/...'
```

本番も同様に `reaction-production` / `/reaction/production/...` で投入する。

Terraform はこのパラメータの ARN を IAM ポリシーに使うだけで、値の読み書きはしない。

## 備考

- Slack 通知 Lambda は rikako (takoikatakotako/rikako) の同名 Lambda をベースにしている
- Webhook URL は Lambda 環境変数に `ssm:<パラメータ名>` という参照だけを入れ、起動時に SSM から取得する。実値を環境変数に置くと `update-function-code` のレスポンス経由でログに露出するため
- 1 バッチに複数の ERROR ログが入った場合は 1 メッセージに集約して送る。1 件ずつ送ると Slack のレート制限（概ね 1 req/sec）に当たり、Lambda の再実行でバッチ先頭から送り直すため重複・未達が起きる。429 が返った場合は `Retry-After` に従ってリトライする
- CloudWatch Logs は at-least-once 配信のため、重複を判別できるよう各ログにイベント ID を付けて送る
- CloudFront のメトリクスは us-east-1 にしか存在せず、アラームと SNS トピックを別リージョンに作る必要があるため本モジュールには含めていない
