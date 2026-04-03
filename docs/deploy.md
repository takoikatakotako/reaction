# デプロイ手順

## 概要

デプロイは GitHub Actions の `workflow_dispatch` で手動実行します。
PR のマージでは自動デプロイされません。

## ワークフロー一覧

| ワークフロー | 対象 | 環境 |
|-------------|------|------|
| `deploy-admin-api-development.yml` | API | 開発 |
| `deploy-admin-api-production.yml` | API | 本番 |
| `deploy-admin-front-development.yml` | フロントエンド | 開発 |
| `deploy-admin-front-production.yml` | フロントエンド | 本番 |

## デプロイ方法

### GitHub UI から

1. GitHub リポジトリの「Actions」タブを開く
2. 左メニューからデプロイしたいワークフローを選択
3. 「Run workflow」をクリック
4. ブランチを選択して「Run workflow」を実行

### GitHub CLI から

```bash
# 開発環境にデプロイ
gh workflow run deploy-admin-api-development.yml --ref <ブランチ名>
gh workflow run deploy-admin-front-development.yml --ref <ブランチ名>

# 本番環境にデプロイ
gh workflow run deploy-admin-api-production.yml --ref main
gh workflow run deploy-admin-front-production.yml --ref main
```

### デプロイ状況の確認

```bash
# 最新の実行状況を確認
gh run list --workflow=deploy-admin-api-development.yml --limit 1
gh run list --workflow=deploy-admin-front-development.yml --limit 1
```

## デプロイの流れ

### API デプロイ

1. Go アプリケーションの Docker イメージをビルド
2. ECR にプッシュ
3. Lambda 関数を更新

### フロントエンド デプロイ

1. Next.js アプリをビルド（静的エクスポート）
2. S3 にアップロード
3. CloudFront のキャッシュを無効化

## 注意事項

- **本番デプロイは `main` ブランチから行う**のが原則です
- 開発環境は feature ブランチから直接デプロイ可能です
- API とフロントエンドは独立してデプロイできます
- DynamoDB のテーブル追加などインフラ変更がある場合は、デプロイ前に `terraform apply` が必要です

## インフラ変更（Terraform）

DynamoDB テーブルの追加など、インフラの変更が必要な場合：

```bash
cd terraform/environments/development  # または production
terraform plan
terraform apply
```

AWS プロファイル:
- 開発: `reaction-development`
- 本番: `reaction-production`
