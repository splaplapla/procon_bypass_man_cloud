# README
[![Run rspec](https://github.com/splaplapla/procon_bypass_man_cloud/actions/workflows/rails_test.yml/badge.svg)](https://github.com/splaplapla/procon_bypass_man_cloud/actions/workflows/rails_test.yml)
[![Run linters](https://github.com/splaplapla/procon_bypass_man_cloud/actions/workflows/rails_security_checks.yml/badge.svg)](https://github.com/splaplapla/procon_bypass_man_cloud/actions/workflows/rails_security_checks.yml)

* https://github.com/splaplapla/procon_bypass_man のサーバです
* 接続状況の可視化, PBM自体の再起動, PBMのバージョンアップ, 設定ファイルのバックアップなどができます

## Installation
```
bundle config set --local without production
bundle install
```

## 自分用サーバとして公開し、PBMから使う方法
Use heroku

```
ProconBypassMan.configure do |config|
  # ...
  config.api_servers = 'https://your-heroku-app.herokuapp.com'
  # ...
end
```

## TODO
* device nameを更新したい
* 認証したい
* ユーザ登録画面を作って、そこからdevice idを入力してユーザとのペアリングをしたい
* デバイスに紐づくセッションは最大１０にする
    * modelのコールバックで削除する感じ
* webから設定を更新して反映できる
* websocketで接続できてPBMへ命令をbroadcastできる
