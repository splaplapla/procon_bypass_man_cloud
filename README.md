# README
* ラズパイからのログを受信するrails application
* rails側からPBMの再起動とかしたい

## Installation
```
bundle config set --local without 'production
bundle install
```

## TODO
* 設定ファイルをアップロードしたい
* device nameを更新したい
* 認証したい
* ユーザ登録画面を作って、そこからdevice idを入力してユーザとのペアリングをしたい
* デバイスに紐づくセッションは最大１０にする
    * modelのコールバックで削除する感じ
* webからコマンドを送信して再起動したり、をしたい
* デバイスに紐づくエラーを見れる
* device, session, eventごとにnestしたcontrollerを作成する
* webから設定を更新して反映できる
