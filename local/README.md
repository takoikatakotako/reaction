# ローカル開発環境

API のテストとローカル実行で使う AWS のモック。

| サービス | イメージ | ポート |
|---|---|---|
| DynamoDB | `amazon/dynamodb-local`（AWS 公式） | 8000 |
| S3 | `adobe/s3mock` | 9000 |

## 使い方

リポジトリルートから:

```bash
make -C local setup   # 起動（テーブル・バケットの作成まで待つ）
make -C local down    # 停止
```

`setup` は `docker compose up -d --wait` なので、初期化コンテナが
テーブルとバケットを作り終えるまでブロックする。固定の `sleep` は不要。

## 作られるもの

- DynamoDB テーブル: `reactions` / `questions` / `notices`
- S3 バケット: `resource.reaction-local.swiswiswift.com`

## LocalStack から移行した理由

LocalStack の Community Edition が 2026-03-23 で終了し、アカウント登録が
必須・**CI での実行には有償契約が必要**になったため（#137）。

当初は S3 を MinIO にする想定だったが、MinIO も公開イメージを引けなく
なっていたため `adobe/s3mock`（Apache 2.0）を採用した。

```
minio/minio      → pull access denied
quay.io/minio    → タグ取得不可
```

## 補足

- DynamoDB Local は認証を検証しないが、コード側は `local` プロファイル用の
  静的な資格情報（`infrastructure/aws.go` の `LocalAccessKeyID` 等）を使う
- `adobe/s3mock` は認証もバケットポリシーも検証しない。バケットは
  `initialBuckets` 環境変数で起動時に作られる
- S3 はパス形式のアドレッシングが必要なため、`aws_s3.go` で
  `UsePathStyle = true` を指定している
