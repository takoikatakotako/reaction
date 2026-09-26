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
pnpm test             # ユニットテスト実行 (Vitest)
```

### API (application/)

```bash
cd application
make run              # ローカル実行 (go run ./api)
make test             # テスト実行 (キャッシュクリア付き)
make build-admin-image  # Dockerイメージビルド
```

`go run api/main.go` のようにファイル単体を指定すると、同じ package の他ファイル
(`logger.go` など) がコンパイル対象から外れて `undefined` になる。`./api` のように
package 単位で指定すること。

ローカル実行には LocalStack が必要（リポジトリルートから実行する）:

```bash
make -C local setup   # DynamoDB / S3 のモックを起動
make -C local down    # 停止
```

### iOS (ios/)

```bash
cd ios
mint bootstrap        # ツールインストール (xcodegen, swiftlint など)
make generate         # Xcode プロジェクト生成 + Package.resolved 配置
make lint             # Lint実行
make test             # ユニットテスト (シミュレータ)
make save-resolved    # Xcode で依存を更新した後、Package.resolved をバージョン管理側へ書き戻す
```

SwiftPM の依存バージョンは `ios/Package.resolved` で固定している（xcodeproj は生成物で gitignore されているため別置き）。

### モバイルの配信

```bash
# Android: 署名付き AAB を作る（Play Console から手動アップロード）
AWS_PROFILE=reaction-production ./scripts/android-release.sh

# iOS: TestFlight 用の ipa を作る（ビルド番号はコミット数から自動採番）
cd ios && make archive && make export
```

Firebase の設定ファイルはリポジトリに置かず SSM がマスター。
`scripts/firebase-config.sh pull android` / `pull ios dev|prod` で取得する。
詳細は `android/README.md` と `ios/README.md`。

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
