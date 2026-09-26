# CI 用のダミー Firebase 設定

google-services プラグインは `app/google-services.json` が無いとビルドを
失敗させる。ここにあるのは、そのビルドを通すためだけの**ダミー**。

実在しない Firebase プロジェクトを指しているので、ここから作った APK は
Crashlytics にも Firebase の何にも繋がらない。CI は lint / ユニットテスト /
`assembleDebug` にしか使わないので、それで足りる。

本物は SSM がマスター（`/reaction/production/firebase/android`）。
手元では `scripts/firebase-config.sh pull android` で取得する。
