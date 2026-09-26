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

Play は同じ `versionCode` の再アップロードを受け付けない。スクリプトが
`git rev-list --count HEAD`（コミット数）から自動で採番するので、普段は
意識しなくてよい。単調増加で、どのコミットのビルドか後から辿れる。

同じコミットで作り直すときだけ明示する。

```bash
ANDROID_VERSION_CODE=628 AWS_PROFILE=reaction-production ./scripts/android-release.sh
```

`build.gradle.kts` の既定値は 1。Play にアップロードしないビルド（手元の
動作確認や CI のテスト）はこれで構わない。

浅いクローンだとコミット数が実際より小さくなり番号が巻き戻るため、
スクリプトは shallow repository を検出して落とす。CI で使うときは
`actions/checkout` に `fetch-depth: 0` を指定すること。

詳細は `scripts/android-signing.sh` の冒頭コメントを参照。

## Crashlytics

Firebase SDK が ContentProvider で自動初期化するため、アプリ側のコードは不要。
`mapping` のアップロードは release のみ有効（`app/build.gradle.kts`）。
今は `isMinifyEnabled = false` なので mapping 自体が生成されない。
