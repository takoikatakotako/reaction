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
受け付けない。`CURRENT_PROJECT_VERSION` は **コミット数 × 100** から自動で
採番しているので、普段は意識しなくてよい。

```bash
make archive             # 62700
make archive RETRY=1     # 62701（同じコミットで作り直すとき）
```

下 2 桁を再配信用に空けてあるのは、コミット数をそのまま使うと番号が衝突する
ため。628 で配信 → 同じコミットを手で 629 にして再配信 → 次のコミットで自動
採番に戻ると、また 629 になる。`RETRY` を使っても次のコミットの番号
`(n+1)×100` を超えないので、そのあと自動採番に戻して構わない。

`RETRY` は 0-99。`project.yml` の `CURRENT_PROJECT_VERSION: 1` は Xcode から
直接ビルドしたときの既定値で、`make archive` はそれを上書きする。

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
秘密鍵は Apple 側にあり、署名も Apple 側で行われる。手元の keychain に秘密鍵が
来るわけではない。

そのため `security find-identity` には配布証明書が出てこない。手元の keychain しか
見ていないだけで、証明書が無いわけではない。証明書の実体はプロビジョニング
プロファイルから確認できる。

```bash
cd ~/Library/Developer/Xcode/UserData/Provisioning\ Profiles/
security cms -D -i <profile>.mobileprovision | plutil -p - | head
```

#### -allowProvisioningUpdates が何をするか

`make archive` が付けている `-allowProvisioningUpdates` は、Apple Developer との
通信を許可するフラグ。`xcodebuild -help` の説明は次のとおり。

> For automatically signed targets, xcodebuild will create and update profiles,
> app IDs, and certificates.

このプロジェクトは `CODE_SIGN_STYLE: Automatic` なので、**証明書が新規に発行され
ないことは保証されない**。クラウド管理証明書自体にも期限に応じた自動ローテーション
がある。

署名資産を一切変更したくない場合は、このフラグを使わず、手元に用意した証明書と
プロファイルで手動署名すること（`CODE_SIGN_STYLE: Manual`、`-exportOptionsPlist`
の `signingStyle: manual` と `provisioningProfiles`）。

参考: [Apple — Cloud-managed certificates](https://developer.apple.com/help/account/certificates/cloud-managed-certificates)
