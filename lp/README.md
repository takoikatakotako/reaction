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
