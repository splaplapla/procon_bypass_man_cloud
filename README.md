# README
[![Run rspec](https://github.com/splaplapla/procon_bypass_man_cloud/actions/workflows/rails_test.yml/badge.svg)](https://github.com/splaplapla/procon_bypass_man_cloud/actions/workflows/rails_test.yml)
[![Run linters](https://github.com/splaplapla/procon_bypass_man_cloud/actions/workflows/rails_security_checks.yml/badge.svg)](https://github.com/splaplapla/procon_bypass_man_cloud/actions/workflows/rails_security_checks.yml)

* https://github.com/splaplapla/procon_bypass_man のサーバです
* 接続状況の可視化, PBM自体の再起動, PBMのバージョンアップ, 設定ファイルのバックアップなどができます

## Development
```
bundle config set --local without production
bundle install
```

## 自分用サーバとして公開し、PBMから使う方法
Use heroku!

```ruby
ProconBypassMan.configure do |config|
  # ...
  config.api_servers = 'https://your-heroku-app.herokuapp.com'
  # ...
end
```

## TODO
* デバイス詳細ページをReactで作る
* 設定エディターをReactで作る
