# iOS

## ビルド前の準備

`GoogleService-Info.plist` はリポジトリに入れていない（SSM がマスター）。

```bash
AWS_PROFILE=reaction-development ./scripts/firebase-config.sh pull ios dev
AWS_PROFILE=reaction-production  ./scripts/firebase-config.sh pull ios prod
```

環境ごとに AWS アカウントが違うので、それぞれ認証して個別に実行する。

## 開発

```bash
cd ios
mint bootstrap     # xcodegen / swiftlint の導入
make generate      # Xcode プロジェクト生成 + Package.resolved 配置
make lint
make test
```

## TestFlight への配信

スキームは `Production`（`com.example.junpei.chemi`）。

```bash
cd ios
make archive
make export
```

`build/export/ReactionProduction.ipa` ができるので、Transporter でアップロード
するか、Xcode の Organizer から配信する。

### ビルド番号

TestFlight は同じ (`MARKETING_VERSION`, `CFBundleVersion`) の再アップロードを
受け付けない。`CURRENT_PROJECT_VERSION` は `git rev-list --count HEAD`
（コミット数）から自動で採番しているので、普段は意識しなくてよい。

単調増加で、どのコミットのビルドか後から辿れる。`project.yml` の
`CURRENT_PROJECT_VERSION: 1` は Xcode から直接ビルドしたときの既定値で、
`make archive` はそれを上書きする。

同じコミットで archive し直すと番号が変わらず弾かれる。そのときだけ明示する。

```bash
make archive BUILD_NUMBER=628
```

浅いクローンだとコミット数が実際より小さくなり番号が巻き戻るため、
`make archive` は shallow repository を検出して落とす。CI で使うときは
`actions/checkout` に `fetch-depth: 0` を指定すること。

### Xcode の Organizer から配信する場合

Organizer の Distribute App は、アップロード時に Xcode が App Store Connect
へ問い合わせてビルド番号を振り直す（`manageAppVersionAndBuildNumber`、既定
YES）。そのため番号を意識する必要はない。

一方 `make export` は `destination: export` で ipa を書き出すだけなので、
この調整は行われない。Transporter に流す場合は ipa に焼かれた番号がそのまま
使われる。上のコミット数採番はそのために入れている。

### 配布証明書について

このチーム（5RH346BQ66）は **Cloud Managed Distribution Certificate** を使っている。
秘密鍵を Apple 側が保持する方式で、署名時に Xcode が取ってくる。

そのため `security find-identity` には配布証明書が出てこない。手元の keychain しか
見ていないだけで、証明書が無いわけではない。証明書の実体はプロビジョニング
プロファイルから確認できる。

```bash
cd ~/Library/Developer/Xcode/UserData/Provisioning\ Profiles/
security cms -D -i <profile>.mobileprovision | plutil -p - | head
```

`make archive` の `-allowProvisioningUpdates` はこのクラウド管理証明書を使うので、
新しく証明書が発行されることはない。
