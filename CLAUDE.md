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
make test             # ユニットテスト (シミュレータは自動選択。SIMULATOR_UDID で指定可)
make save-resolved    # Xcode で依存を更新した後、Package.resolved をバージョン管理側へ書き戻す
```

SwiftPM の依存バージョンは `ios/Package.resolved` で固定している（xcodeproj は生成物で gitignore されているため別置き）。

### モバイルの配信

**配信用のビルドは必ず `main` から作る。** TestFlight や内部テストへの配信も含む。
ビルド番号をコミット数から採番しているため、ブランチから配信すると main が
これから使う番号を先に消費してしまい、採番が破綻する（実際に起きた）。
PR はマージしてから、`main` を pull してビルドする。

```bash
# Android: ビルドから Play 内部テストへのアップロードまで一発
# ※ デベロッパー確認の鍵未登録で commit が 403 になっていた。鍵は登録済みだが
#   API 経由は未検証（android/README.md「デベロッパー確認の鍵未登録でブロックされた件」）
UPLOAD=1 AWS_PROFILE=reaction-production ./scripts/android-release.sh

# AAB を作るだけなら
AWS_PROFILE=reaction-production ./scripts/android-release.sh

# iOS: ビルドから TestFlight へのアップロードまで一発
AWS_PROFILE=reaction-production ./scripts/ios-release.sh production
AWS_PROFILE=reaction-production ./scripts/ios-release.sh development

# ipa を作るだけなら（ビルド番号はコミット数から自動採番）
cd ios && make archive && make export                          # 本番
cd ios && make archive-development && make export-development  # 開発
```

Firebase の設定ファイルはリポジトリに置かず SSM がマスター。
`scripts/firebase-config.sh pull android` / `pull ios dev|prod` で取得する。
詳細は `android/README.md` と `ios/README.md`。

ストアへの公開（製品版 / App Store）はどちらも手動操作が要る。Play は
管理対象の公開がオン、iOS はリリース方法が手動。審査が通っても自分で
公開ボタンを押すまで出ない。

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
