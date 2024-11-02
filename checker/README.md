## ReactionGenerator

これは反応機構一覧が間違って設定されていないかチェックし、出力するためのツールです。
`resource` の中にある `reaction.json` と `images` ディレクトリの中身をチェックし、問題がなければ `output` ディレクトリに書き出します。

## Set Up

このリポジトリをダウンロードし、`resource-go` ディレクトリの中に入ってください。

```
$ cd reaction-go
```

`resource-go` の中で以下のコマンドを実行してください。

```
$ go run checker.go    // ビルドが必要な場合
$ ./checker
```

`output` ディレクトリに `reactions.json` ファイルと `images` ディレクトリが生成されれば正しく動いています。


## Add Reaction

反応機構を追加する時は、 `resource` ディレクトリの `reactions.json` を VSCode などのエディタで開きます。
`reactions.json` の一番最後の項目に `,` を追加して改行し、新たに以下の項目を追加します。
命名は全て英語の小文字を使い、スペースやアンダーバーの代わりにハイフンを使ってください。

```
 {
  "directoryName": "",
  "english": "",
  "japanese": "",
  "thmbnailName": "",
  "generalFormulas": [
   {
    "imageName": ""
   }
  ],
  "mechanisms": [
   {
    "imageName": ""
   }
  ],
  "examples": [
   {
    "imageName": ""
   }
  ],
  "supplements": [
   {
    "imageName": ""
   }
  ],
  "suggestions": [],
  "tags": []
 }
```

- `directoryName` は画像が入るフォルダの名前です。
- `english` は反応の英語名です。
- `japanese` は反応の日本語名です。
- `thmbnailName` はサムネイルの画像名です。
- `generalFormulas` は一般式が入ります。複数入力することができます。
- `mechanisms` は反応機構が入ります。 複数入力することができます。
- `examples` はサンプルが入ります。 複数入力することができます。
- `supplements` は補足が入ります。 複数入力することができます。
- `suggestions` は検索候補が入ります。`suggestions` の中にある文字列で検索をひっかけることができます。複数入力することができます。
- `tags` はタグが入ります。将来的にはタグ検索機能に使おうと思います。複数入力することができます。

`reactions.json` を編集が終わったら `resource/images` の中に `directoryName` で定義したフォルダを作り、その中に画像を入れます。
最後にチェッカーを実行して、エラーが出なければ完了です。
outputディレクトリを zip で圧縮し、小野に送ってください。

```
$ ./checker
```


## Buid

for windows

```
$ GOOS=windows GOARCH=amd64 go build -o checker.exe checker.go 
```
