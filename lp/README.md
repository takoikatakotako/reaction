# シン反応機構 ランディングページ

`chemist.swiswiswift.com` で配信している静的なランディングページ。

## 構成

素の HTML と CSS のみ。ビルド不要。画面幅で 3 つの CSS を出し分ける。

```
index.html
css/phone.css   ～800px
css/ipad.css    800px～1200px
css/pc.css      1200px～
images/
```

## 手元で見る

```bash
cd lp && python3 -m http.server 8000
```

## 経緯

もとは Organizations の管理アカウント（Onojun）の S3 に置かれており、
バージョン管理されていなかった。S3 から救出してここに取り込んだ。

同じバケットのルートには 2021 年の Create React App のビルドが残っていたが、
メンテナンスされていないため配信をこのランディングページだけにした。

## 配信

`reaction-production` アカウントの S3 + CloudFront。Terraform は
`terraform/modules/lp` と `terraform/environment/production`。

`main` の `lp/` が変わると `deploy-lp-production.yml` が S3 へ sync して
CloudFront のキャッシュを消す。ビルドが無いので、ファイルがそのまま配信内容になる。

DNS は Cloudflare 管理（Route53 ではない）。CNAME を CloudFront の
ドメインへ向けている。

## 移行手順（Onojun アカウントから reaction-production へ）

CloudFront は**同じ alternate domain name を 2 つの distribution に登録できない**。
旧 distribution（Onojun アカウントの `E7K0W7JYJMRK`）が
`chemist.swiswiswift.com` を保持しているため、新しい distribution に最初から
alias を入れると `CNAMEAlreadyExists` で作成に失敗する。

DNS の CNAME を変えるだけでは CloudFront 側の所有権は移らない。
`associate-alias` で明示的に移す必要がある。

1. **ACM の検証レコードを Cloudflare に追加**（プロキシ OFF / DNS only）
   現在の配信には影響しない。

2. **`lp_aliases = []` のまま apply**
   alias 無しで S3 と CloudFront ができる。

3. **`LP_PRODUCTION_DISTRIBUTION_ID` をリポジトリ変数に登録**して デプロイ
   `module.lp.distribution_id` の値。登録するまでワークフローは起動しない。

4. **CloudFront の標準ドメインで表示を確認**
   `https://<distribution_domain_name>/`。本番はまだ旧環境を向いている。

5. **所有権移転用の TXT レコードを Cloudflare に追加**（プロキシ OFF）

   ```
   名前  _chemist.swiswiswift.com
   値    <新しい distribution のドメイン>
   ```

6. **alias を移す**

   ```bash
   AWS_PROFILE=reaction-production aws cloudfront associate-alias \
     --target-distribution-id <新しい distribution ID> \
     --alias chemist.swiswiswift.com
   ```

7. **Cloudflare の CNAME を新しい CloudFront のドメインへ差し替え**

8. **`lp_aliases = ["chemist.swiswiswift.com"]` にして apply**
   実際の状態と Terraform を揃える。

9. **旧環境を削除**
   Onojun アカウントの CloudFront `E7K0W7JYJMRK` と S3
   `chemist.swiswiswift.com`。2021 年の Create React App のビルドもここで消える。

切り戻しは、7 まで進んでいれば Cloudflare の CNAME を戻すだけ。
