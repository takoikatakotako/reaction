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

`build/export/Reaction.ipa` ができるので、Transporter でアップロードするか、
Xcode の Organizer から配信する。

### ビルド番号

TestFlight は同じ (`MARKETING_VERSION`, `CFBundleVersion`) の再アップロードを
受け付けない。`project.yml` の `CURRENT_PROJECT_VERSION` は 1 のままなので、
アップロードし直すときは `BUILD_NUMBER` を上げる。

### 配布証明書について

`make archive` は `-allowProvisioningUpdates` を付けているので、手元に配布証明書
（Apple Distribution）が無ければ Apple Developer 側に作りに行く。**配布証明書は
発行枠に限りがある**（チームあたり数枚）ので、既に他の Mac で発行済みでないか
確認してから実行すること。既にある場合は、そちらから書き出した .p12 を
インポートするほうが枠を消費しない。

Xcode の Organizer から Archive → Distribute App を使う場合も同じ扱いになる。
