# Android

## ビルド前の準備

`google-services.json` はリポジトリに入れていない（SSM がマスター）。
無いと google-services プラグインがビルドを失敗させるので、先に取得する。

```bash
AWS_PROFILE=reaction-production ./scripts/firebase-config.sh pull android
```

Firebase プロジェクトは本番のみ（`reaction-9c595`）。デバッグビルドの
クラッシュも同じプロジェクトに届く。

CI は AWS を使わず `ci/google-services.json`（ダミー）をコピーしている。
lint / ユニットテスト / `assembleDebug` を通すだけなのでそれで足りる。
Firebase に繋ぐ動作確認は手元か実機で行う。

## ビルド

```bash
cd android
./gradlew assembleDebug
./gradlew testDebugUnitTest
./gradlew lintDebug
```

## Play への配信

アップロード鍵も SSM がマスター。設定ファイルの取得・署名付きビルド・
署名の検証をまとめて行うスクリプトがある。

```bash
AWS_PROFILE=reaction-production ./scripts/android-release.sh
```

`android/app/build/outputs/bundle/release/app-release.aab` ができるので、
Play Console → テスト → 内部テスト → 新しいリリースを作成 からアップロードする。

アップロード前に AAB の署名がアップロード鍵と一致することを検証している。
鍵を取り違えると Play が受け付けないため、そこで落とす。

### バージョン

Play は同じ `versionCode` の再アップロードを受け付けない。上げ直すときは
`app/build.gradle.kts` の `versionCode` を上げる。

詳細は `scripts/android-signing.sh` の冒頭コメントを参照。

## Crashlytics

Firebase SDK が ContentProvider で自動初期化するため、アプリ側のコードは不要。
`mapping` のアップロードは release のみ有効（`app/build.gradle.kts`）。
今は `isMinifyEnabled = false` なので mapping 自体が生成されない。
