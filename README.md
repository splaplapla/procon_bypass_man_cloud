# README
[![Run rspec](https://github.com/splaplapla/procon_bypass_man_cloud/actions/workflows/rails_test.yml/badge.svg)](https://github.com/splaplapla/procon_bypass_man_cloud/actions/workflows/rails_test.yml)
[![Run linters](https://github.com/splaplapla/procon_bypass_man_cloud/actions/workflows/rails_security_checks.yml/badge.svg)](https://github.com/splaplapla/procon_bypass_man_cloud/actions/workflows/rails_security_checks.yml)

* https://github.com/splaplapla/procon_bypass_man のサーバです
* https://pbm-cloud.herokuapp.com で公開しています

## 機能
* PBMとの接続状況の可視化
* Raspberry PIの再起動
* PBMのバージョンアップ
* 設定ファイルのバックアップ、公開
* ライブストリーミングのコメント連携
  - youtube live(WI))
    * gcp appが非公開なので公開にする必要がある
  - twitch

## procon_bypass_manを登録する方法
* `app.rb` の `config.api_servers` の行をアンコメントアウトする
* `procon_bypass_man` を起動する
* https://pbm-cloud.herokuapp.com でユーザ登録をする
* `/usr/share/pbm/shared/device_id` もしくは実行しているディレクトリにある `device_id` の中身を https://pbm-cloud.herokuapp.com/devices/new に貼り付ける

```ruby
ProconBypassMan.configure do |config|
  # ...
  config.api_servers = 'https://pbm-cloud.herokuapp.com' # これを追加する
  # ...
end
```

## Development
### インストール方法
```
bundle config set --local without production
bundle install
```

### TODO
* デバイス詳細ページをReactで作る
  - 現在は状態管理をjQueryでDOMをいじっているのでかなり厳しい状態
* 設定エディター機能
  - 作り途中(import-mapへの移行でtypescriptが使えなくなってしまい元に戻る)
* 設定ファイル同士のdiff機能
