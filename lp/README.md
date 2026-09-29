# シン反応機構 ランディングページ

`chemist.swiswiswift.com` で配信している静的なランディングページ。

## 構成

素の HTML と CSS のみ。ビルド不要。

```
index.html
css/style.css
images/
```

flexbox で組んでいて、800px 以下で縦積みに切り替わる。ブレークポイントは
折り返しの都合で 1 つだけ。

## 手元で見る

```bash
cd lp && python3 -m http.server 8000
```

## 経緯

もとは Organizations の管理アカウント（Onojun）の S3 に置かれており、
バージョン管理されていなかった。S3 から救出してここに取り込んだ。

同じバケットのルートには 2021 年の Create React App のビルドが残っていたが、
メンテナンスされていないため配信をこのランディングページだけにした。

## /resource/ はアプリの画像

`chemist.swiswiswift.com/resource/` 配下は、**本番配信中の Android アプリが
参照している**反応機構の画像と JSON。ランディングページとは無関係。

```kotlin
// android/app/src/main/java/com/swiswiswift/chemist/Config.kt
const val RESOURCE_URL = "https://chemist.swiswiswift.com/resource/"
const val IMAGE_URL = "${RESOURCE_URL}images/"
```

移設前はランディングページと同じバケットに同居していた。LP のデプロイは
`aws s3 sync --delete` なので、同居させるとデプロイのたびに消える。
**別バケット（`reaction-production-lp-resource`）に分け**、CloudFront の
`/resource/*` だけそちらへ振り分けている。

`lp/` には含めない。デプロイ対象外。

アプリ側を `resource.reaction-production.swiswiswift.com` に向けられれば
このバケットは不要になるが、そちらは UUID 命名で互換性が無く、アプリの
リリースも要る。

## 配信

`reaction-production` アカウントの S3 + CloudFront。Terraform は
`terraform/modules/lp` と `terraform/environment/production`。

`main` の `lp/` が変わると `deploy-lp-production.yml` が S3 へ sync して
CloudFront のキャッシュを消す。ビルドが無いので、ファイルがそのまま配信内容になる。

DNS は Cloudflare 管理（Route53 ではない）。CNAME を CloudFront の
ドメインへ向けている。

## 移行手順（Onojun アカウントから reaction-production へ）

> **2026-09-29 に移行済み。** 手順 1〜9 は完了している。
> 残っているのは手順 10（旧環境の削除）のみ。旧 distribution
> `E7K0W7JYJMRK` は無効化済みで配信はしていないが、切り戻しのために
> 残してある。以下は経緯と切り戻しのための記録。

CloudFront は**同じ alternate domain name を 2 つの distribution に登録できない**。
旧 distribution（Onojun アカウントの `E7K0W7JYJMRK`）が
`chemist.swiswiswift.com` を保持しているため、新しい distribution に最初から
alias を入れると `CNAMEAlreadyExists` で作成に失敗する。

DNS の CNAME を変えるだけでは所有権は移らない。CloudFront は alias の
所有先でルーティングするため、`associate-alias` で明示的に移す必要がある。

さらに**異なる AWS アカウント間で `associate-alias` を使うには、旧
distribution を無効化してからでないと実行できない**。つまり移行には
停止時間が伴う。

停止を避ける方法として wildcard（`*.swiswiswift.com`）を使う手順も
公式にはあるが、`swiswiswift.com` の他のサブドメインは別アカウントで
配信しており、ワイルドドメインを 1 アカウントが握ると後々の取り回しが
悪くなる。ランディングページなので短時間の停止を受け入れる。

参考: [Moving an alternate domain name to a different distribution](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/alternate-domain-names-move-options.html)

### 停止前（影響なし）

1. **ACM の検証レコードを Cloudflare に追加**（プロキシ OFF / DNS only）

2. **`lp_aliases = []` のまま apply**
   alias 無しで S3 と CloudFront ができる。

3. **`LP_PRODUCTION_DISTRIBUTION_ID` をリポジトリ変数に登録**してデプロイ
   `module.lp.distribution_id` の値。登録するまでワークフローは起動しない。

4. **CloudFront の標準ドメインで表示を確認**
   `https://<distribution_domain_name>/`。ここで中身を十分に確認しておく。
   切り戻しに手間がかかるため、この段階での確認が実質最後の砦になる。

5. **所有権移転用の TXT レコードを Cloudflare に追加**（プロキシ OFF）

   ```
   名前  _chemist.swiswiswift.com
   値    <新しい distribution のドメイン>
   ```

### 停止を伴う区間

ここから `chemist.swiswiswift.com` が見えなくなる。CloudFront の
変更反映に数分から十数分かかるため、**30 分程度の停止を見込む**。

6. **旧 distribution を無効化し、`Deployed` になるまで待つ**

   ```bash
   AWS_PROFILE=swiswiswift aws cloudfront get-distribution-config --id E7K0W7JYJMRK
   # Enabled を false にして update-distribution（ETag が必要）
   AWS_PROFILE=swiswiswift aws cloudfront wait distribution-deployed --id E7K0W7JYJMRK
   ```

7. **alias を移す**

   ```bash
   AWS_PROFILE=reaction-production aws cloudfront associate-alias \
     --target-distribution-id <新しい distribution ID> \
     --alias chemist.swiswiswift.com
   AWS_PROFILE=reaction-production aws cloudfront wait distribution-deployed \
     --id <新しい distribution ID>
   ```

8. **Cloudflare の CNAME を新しい CloudFront のドメインへ差し替え**

   ここで復旧する。

### 停止後

9. **`lp_aliases = ["chemist.swiswiswift.com"]` にして apply**
   実際の状態と Terraform を揃える。

10. **しばらく置いてから旧環境を削除**
    Onojun アカウントの CloudFront `E7K0W7JYJMRK` と S3
    `chemist.swiswiswift.com`。2021 年の Create React App のビルドも
    ここで消える。**切り戻しの可能性が無くなるまで消さない。**

### 切り戻し

手順 7 を実行したあとは、CNAME を戻すだけでは戻らない。逆順に
やり直すことになる。

1. 新 distribution を無効化して `Deployed` を待つ
2. 旧 distribution を有効化する
3. `associate-alias` で alias を旧 distribution へ戻す
4. Cloudflare の CNAME を旧 distribution のドメインへ戻す
5. **`lp_aliases = []` に戻して apply する**

5 を忘れると Terraform の宣言が実態とずれる。移行手順 9 を終えた状態では
`lp_aliases = ["chemist.swiswiswift.com"]` になっており、そのまま次の
apply を打つと、旧 distribution が alias を持っているのに新 distribution に
付け直そうとして `CNAMEAlreadyExists` で失敗する。

このモジュールは `enabled = true` を固定しているため、apply で新
distribution は再び有効になる。alias が空なら誰の配信にも影響しない。
apply 後に `terraform plan` が `No changes` になることを確認しておくこと。

こちらも停止を伴うため、手順 4 の確認を丁寧にやること。
