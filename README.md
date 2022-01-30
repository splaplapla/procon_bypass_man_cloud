# README
[![Run rspec](https://github.com/splaplapla/procon_bypass_man_cloud/actions/workflows/rails_test.yml/badge.svg)](https://github.com/splaplapla/procon_bypass_man_cloud/actions/workflows/rails_test.yml)
[![Run linters](https://github.com/splaplapla/procon_bypass_man_cloud/actions/workflows/rails_security_checks.yml/badge.svg)](https://github.com/splaplapla/procon_bypass_man_cloud/actions/workflows/rails_security_checks.yml)

* https://github.com/splaplapla/procon_bypass_man のサーバです
* 接続状況の可視化, PBM自体の再起動, PBMのバージョンアップ, 設定ファイルのバックアップなどができます
* https://pbm-cloud.herokuapp.com で公開しています

## 使い方
* `app.rb` の `config.api_servers` の行に `https://pbm-cloud.herokuapp.com` を追加する
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
* 設定エディターをReactで作る
