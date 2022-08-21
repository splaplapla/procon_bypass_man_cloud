source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'

gem 'rails', "7.0.3.1"
gem 'mysql2'
gem 'puma'
gem 'cssbundling-rails'
gem 'importmap-rails'
gem 'propshaft'
gem 'kaminari'
gem 'sorcery'
gem 'redis'
gem 'redis-namespace'
gem 'connection_pool'
gem 'newrelic_rpm'
gem 'acts-as-taggable-on'
gem 'omniauth-twitch'
gem 'omniauth-google-oauth2'
gem 'omniauth-rails_csrf_protection'
gem 'rouge'
gem "chartkick"
gem 'stimulus-rails'
gem "rmagick" # グレースケース化とピクセルの色を取得しているだけなのでoverkillかも

# 設定ファイルのパースとバリデーションのために使っている
gem 'procon_bypass_man'

group :production do
  gem 'pg'
end

gem 'bootsnap', require: false

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails'
  gem 'pry'
  gem 'factory_bot_rails'
end

group :test do
  gem 'bundle-audit'
  gem 'mock_redis'
  gem 'timecop'
  gem 'json-schema'
end

group :development do
  gem 'listen'
  gem 'brakeman'
  gem 'foreman'
  gem "action_cable_client"
end
