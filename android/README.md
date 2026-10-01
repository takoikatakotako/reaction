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

commit には既定で `changesInReviewBehavior=ERROR_IF_IN_REVIEW` を付けている。
省略すると審査中の変更をキャンセルして再送信する挙動になり、製品版の審査中に
内部テストを上げると巻き込むため。審査中の場合はエラーで止まる。

ただし Play は、アプリに未審査の変更が残っていると、代わりに
`changesNotSentForReview=true` を要求してくる。逆に未審査の変更が無い状態で
これを付けると `must not be set` で 400 になる。どちらかに固定すると
もう一方の状態で落ちるので、まず `ERROR_IF_IN_REVIEW` で試し、
`changesNotSentForReview` を要求されたときだけ付けて入れ直している。

`changesNotSentForReview=true` は変更を確定するだけで審査には出さない。
内部テストの配信自体は審査を必要としない。審査に出すかどうかは Play Console
から人が判断する。

### Play API の 403（未解決・2026-10-02 時点）

未審査の変更が残っていない状態で commit すると、Play は変更を自動で審査に
送ろうとする。この経路で 403 が返る。

```
403 PERMISSION_DENIED
To meet Play Console requirements, your app's package name must be registered
to your verified developer identity.
```

原因は **Android デベロッパーの確認における署名鍵の未登録**。Play Console の
確認ページ上は「登録済み」と表示されていても、検出された鍵がすべて登録されて
いるとは限らない。製品版を審査に送ろうとしたときの事前チェックで、未登録の
鍵が 1 つ名指しされて判明した。

同じ壁は手動操作でも当たる。「API だから落ちる」のではなく、**審査に出す経路
だけが弾かれる**。内部テストへの配信は審査を経由しないので、手動・API とも通る。

対処は確認ページで該当の鍵を登録すること。登録後しばらくは「審査中」になる。

鍵は 3 種類あって紛らわしい。

| 鍵 | 誰が持つか | 用途 |
|---|---|---|
| アプリ署名鍵 | Google | Play が配信用に署名し直す鍵。取り出せない |
| アップロード鍵 | SSM（`scripts/android-signing.sh`） | 手元で AAB に署名する鍵 |
| デベロッパー確認に登録する鍵 | 登録するだけ | 上記とは別にもう 1 つ必要だった |

指紋は Play Console の **Google Play による保護 → Play アプリ署名の管理**
（アプリ署名鍵・アップロード鍵）と、**Android デベロッパーの確認 → パッケージ名**
（登録済みの鍵）で確認できる。

これが解消するまで、製品版に出すビルドは Play Console から手動でアップロード
する。`UPLOAD=1` を付けなければ AAB だけ作れる。

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

**配信用のビルドは `main` から作る。** 採番がコミット数に依存しているため、
ブランチから配信すると main がこれから使う番号を先に消費してしまう。

実際に壊した。クラッシュボタン入りの確認用ビルドを 667 コミットのブランチから
`66700` で上げたところ、main は 665 コミットで `66500`、PR をマージしても 667 =
`66700` にしかならず、`RETRY` は下 2 桁なので `666xx` からは `66700` を超えられ
なくなった。`ANDROID_VERSION_CODE` を手で指定して抜けるまで尾を引いた。

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
今は `isMinifyEnabled = false` なので mapping 自体が生成されない（#161）。

実機で疎通を確認済み（2026-10-02、Pixel 6a / Android 17）。難読化解除された
スタックトレースが行番号まで届くところまで見ている。

確認するときは次のログの流れを追う。`adb logcat | grep FirebaseCrashlytics`。

```
Handling uncaught exception "java.lang.RuntimeException: ..." from thread main
Persisting fatal event for session <id>
Finalizing report for session <id>
Sending report through Google DataTransport: <id>
Crashlytics report successfully enqueued to DataTransport: <id>
Deleted report file: .../priority-reports/<id>
Completed exception processing. Invoking default exception handler.
```

**次回起動時の `No crash reports are available to be sent.` は失敗ではない。**
Crashlytics はクラッシュした瞬間に priority-report として送信キューに積み、
ファイルを削除する。だから再起動時には「送るべき未送信レポートがもう無い」
状態になる。実際の送信結果は `TRuntime.CctTransportBackend` の行で確認する。

```
Making request to: https://crashlyticsreports-pa.googleapis.com/v1/firelog/legacy/batchlog
Status Code: 200
```
