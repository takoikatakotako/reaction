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
make archive BUILD_NUMBER=2
make export
```

`build/export/ReactionProduction.ipa` ができるので、Transporter でアップロード
するか、Xcode の Organizer から配信する。

### ビルド番号

TestFlight は同じ (`MARKETING_VERSION`, `CFBundleVersion`) の再アップロードを
受け付けない。`project.yml` の `CURRENT_PROJECT_VERSION` は 1 のままなので、
アップロードし直すときは `BUILD_NUMBER` を上げる。

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
