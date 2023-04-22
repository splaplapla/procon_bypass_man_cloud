# README
[![Run rspec](https://github.com/splaplapla/procon_bypass_man_cloud/actions/workflows/rails_test.yml/badge.svg)](https://github.com/splaplapla/procon_bypass_man_cloud/actions/workflows/rails_test.yml)
[![Run linters](https://github.com/splaplapla/procon_bypass_man_cloud/actions/workflows/rails_security_checks.yml/badge.svg)](https://github.com/splaplapla/procon_bypass_man_cloud/actions/workflows/rails_security_checks.yml)

* https://github.com/splaplapla/procon_bypass_man の運用を楽にするWEBアプリケーションです
* https://pbm-cloud.jiikko.com で公開しています

## 機能
* PBMとの接続状況の可視化
* Raspberry PIの再起動
* PBMのバージョンアップ
* 設定ファイルのバックアップ、公開
* ライブストリーミングのコメント連携
  * youtube live(WIP)
    * gcp appが非公開なので公開にする必要がある
  * twitch
    * https://zenn.dev/jiikko/articles/3c06c20322dd84
* スプラトゥーン2, 3専用機能
    * 自動ドット打ち

## procon_bypass_manを登録する方法
デバイスIDを https://pbm-cloud.jiikko.com に登録する必要があります。

* `app.rb` の `config.api_servers` の行をアンコメントアウトする
* `procon_bypass_man` を起動する。これでデバイスIDが生成されます。
* https://pbm-cloud.jiikko.com でユーザ登録をする
* Raspberry PI内の`/usr/share/pbm/shared/device_id` もしくは実行しているディレクトリにある `device_id` の中身を https://pbm-cloud.jiikko.com/devices/new に貼り付ける

```ruby
ProconBypassMan.configure do |config|
  # ...
  config.api_servers = 'https://pbm-cloud.jiikko.com' # これを追加する
  # ...
end
```

## Development
### インストール方法
#### Mac
```
brew install imagemagick mysql@5.7 redis
bundle config set --local without production
bundle install
```

#### docker
```
docker compose build
docker compose run --rm web bin/rake db:create db:migrate
docker compose run --rm web bin/rake db:seed
docker compose run --rm web yarn
docker compose up
```

### デバッグ
* デバイス詳細webページのaction cable js channelに通知を送る
  * `ActionCable.server.broadcast(device.unique_key, { type: :loaded_config })`
  * `ActionCable.server.broadcast(device.unique_key, { type: :device_is_active })`
      * pingのレスポンス. デバイス詳細画面にあるモーダルのサブミットボタンがクリックできるようになる
* パフォーマンスモニタリングの数値を書き込む

```ruby
ProconPerformanceMetric::WriteService.new.execute(
  timestamp: "2022-07-16 12:21:00+09:00",
  time_taken_max: "0.168",
  time_taken_p50: "0.015",
  time_taken_p95: "0.016",
  time_taken_p99: "00.24",
  write_time_max: "0.168",
  write_time_p50: "0.001",
  read_time_max: "0.168",
  read_time_p50: "0.012",
  interval_from_previous_succeed_max: "0.168",
  interval_from_previous_succeed_p50: "0.015",
  external_input_time_max: "0.015",
  read_error_count: "0",
  write_error_count: "491",
  load_agv: "0.49-0.5-0.55",
  gc_count: 3,
  gc_time: 1.1,
  device_uuid: 'd1',
  succeed_rate: 1,
  collected_spans_size: 4422,
)
```

### TODO
* デバイス詳細ページをReactで作る
  - 現在は状態管理をjQueryでDOMをいじっているのでかなり厳しい状態
* 設定エディター機能
* 設定ファイル同士のdiff機能
