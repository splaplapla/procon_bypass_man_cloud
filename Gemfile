source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.2'

gem 'rails', "6.1.5.1"
gem 'mysql2'
gem 'puma'
gem 'sass-rails'
gem 'webpacker'
gem 'kaminari'
gem 'sorcery'
gem 'redis'
gem 'newrelic_rpm'
gem 'acts-as-taggable-on'
gem 'omniauth-google-oauth2'
gem 'omniauth-rails_csrf_protection'

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
end

group :development do
  gem 'listen'
  gem 'brakeman'
  gem 'foreman'
  gem "action_cable_client"
end
