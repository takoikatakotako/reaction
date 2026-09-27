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

### アップロードまで一発でやる

```bash
UPLOAD=1 AWS_PROFILE=reaction-production ./scripts/android-release.sh
```

リリースノートを指定する場合:

```bash
UPLOAD=1 RELEASE_NOTES_FILE=notes.txt AWS_PROFILE=reaction-production ./scripts/android-release.sh
```

`TRACK=internal`（既定）、`STATUS=completed`（既定。`draft` にすると
Play Console で手動公開になる）も指定できる。

fastlane や Google のクライアントライブラリは使わず、curl で
Play Developer API v3 を直接叩いている。依存を増やさないため。

1. サービスアカウントを借用してアクセストークンを取る
2. edit を作る
3. AAB をアップロード
4. トラックに versionCode を載せる
5. edit を commit

commit するまでは何も公開されない。途中で落ちた場合は edit を破棄するので、
Play Console に未完了の編集が残らない。

commit には `changesInReviewBehavior=ERROR_IF_IN_REVIEW` を付けている。省略すると
審査中の変更をキャンセルして再送信する挙動になり、製品版の審査中に内部テストを
上げると巻き込むため。審査中の場合はエラーで止まる。

### Play の認証（鍵ファイルは使わない）

`play-publisher@takoikatakotako-management.iam.gserviceaccount.com` を
**権限借用**して使う。AWS の AssumeRole に相当する仕組みで、手元の gcloud の
認証情報でこの SA になりすまし、1 時間で失効するトークンを取る。

**サービスアカウントの鍵ファイルは作らない。** 漏洩・失効管理・保管場所の
心配が要らないため。

事前に `gcloud auth login` しておくこと。借用できるのは gcp-iac の
`play_publisher_impersonators` に列挙された principal だけ。

Play Developer API のスコープは `cloud-platform` に含まれないため、
`gcloud --impersonate-service-account` では足りない。IAM Credentials API の
`generateAccessToken` に scope を明示して取っている。

### バージョン

Play は同じ `versionCode` の再アップロードを受け付けない。スクリプトが
**コミット数 × 100** から自動で採番するので、普段は意識しなくてよい。

```bash
# 62700
AWS_PROFILE=reaction-production ./scripts/android-release.sh

# 62701（同じコミットで作り直すとき）
RETRY=1 AWS_PROFILE=reaction-production ./scripts/android-release.sh
```

下 2 桁を再配信用に空けてあるのは、コミット数をそのまま使うと番号が衝突する
ため。628 で配信 → 同じコミットを手で 629 にして再配信 → 次のコミットで自動
採番に戻ると、また 629 になる。`RETRY` を使っても次のコミットの番号
`(n+1)×100` を超えないので、そのあと自動採番に戻して構わない。

`RETRY` は 0-99 の整数。範囲外・負値・非数値はスクリプトが弾く。空文字
（`RETRY=`）は未指定として 0 に倒す。採番の挙動は
`scripts/test-version-numbering.sh` でテストしている。

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
