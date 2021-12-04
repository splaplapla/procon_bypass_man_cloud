source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.2'

gem 'rails'
gem 'mysql2'
gem 'puma'
gem 'sass-rails'
gem 'webpacker'
# gem 'bcrypt', '~> 3.1.7'
gem 'kaminari'
gem 'sorcery'

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
end
