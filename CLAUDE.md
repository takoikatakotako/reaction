# Reaction

化学反応の情報管理・表示システム。複数プラットフォーム（Web管理画面、API、iOS/Android）で反応データを管理・配信する。

## ディレクトリ構成

```
reaction/
├── admin/          # 管理画面 (Next.js 15 + TypeScript)
├── application/    # バックエンドAPI (Go + Echo)
├── ios/            # iOSアプリ (Swift)
├── android/        # Androidアプリ
├── checker/        # 反応データ検証ツール (Go)
├── terraform/      # AWSインフラ (Lambda, DynamoDB, S3, CloudFront)
├── html/           # 静的HTMLファイル
├── local/          # ローカル開発用設定
└── documents/      # ドキュメント
```

## 技術スタック

- **管理画面**: Next.js 15.3.0, React 19, TypeScript 5, pnpm
- **API**: Go 1.22+, Echo v4, AWS SDK v2
- **iOS**: Swift, SwiftUI, Firebase
- **インフラ**: AWS (Lambda, DynamoDB, S3, CloudFront), Terraform
- **CI/CD**: GitHub Actions

## 開発コマンド

### 管理画面 (admin/)

```bash
cd admin
pnpm install          # 依存関係インストール
pnpm dev              # 開発サーバー起動 (Turbopack)
pnpm build            # ビルド
pnpm lint             # Lint実行
```

### API (application/)

```bash
cd application
go test ./...         # テスト実行
make test             # テスト実行 (キャッシュクリア付き)
make build-admin-image  # Dockerイメージビルド
```

### デプロイ

管理画面:
```bash
cd admin
make build-development && make deploy-development   # 開発環境
make build-production && make deploy-production     # 本番環境
```

## 環境

### URL

| 種別 | 開発環境 | 本番環境 |
|------|----------|----------|
| 管理画面 | `admin.reaction-development.swiswiswift.com` | `admin.reaction-production.swiswiswift.com` |
| API | `admin.reaction-development.swiswiswift.com` | `admin.reaction-production.swiswiswift.com` |
| リソース | `reaction-development.swiswiswift.com/resource/image` | `reaction-production.swiswiswift.com/resource/image` |

### AWS Profile

- `reaction-development` - 開発環境
- `reaction-production` - 本番環境
- `reaction-management` - 管理用

## GitHub Actions ワークフロー

- `test-admin-api.yml` - APIテスト (PR時自動実行)
- `test-admin-front.yml` - フロントエンドテスト (PR時自動実行)
- `test-terraform.yml` - Terraformフォーマットチェック
- `deploy-admin-api-*.yml` - APIデプロイ
- `deploy-admin-front-*.yml` - フロントデプロイ
- `sync-dynamodb-dev-to-prod.yml` - DynamoDBデータ同期
- `sync-s3-resource-dev-to-prod.yml` - S3リソース同期

## コーディング規約

- Go: 標準のgofmt
- TypeScript: ESLint + Prettier
- コミットメッセージ: 日本語OK
