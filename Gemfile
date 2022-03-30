source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.3'

# Core
gem 'rails', '~> 5.2.2'

# Middleware
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 4.3'

# default
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# Scaffold作成時にJSON関連のコードを生成しないようにするためコメントアウト
# gem 'jbuilder', '~> 2.5'

# default js
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'

# has_secure_passwordを使用するために必要なgem
gem 'bcrypt', '~> 3.1.11'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# enumをi18n化するgem
gem 'enum_help'

# ページネーション機能(railsが５系なのでバージョン指定)
gem 'kaminari', '~> 0.17.0'
gem 'kaminari-bootstrap', '~> 3.0.1'

# テストデータを生成するときに使うgem
gem 'faker'

# slim
gem 'slim-rails'
gem 'html2slim'

# アプリ名を変更するときに必要なgem
gem 'rename'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # デバックツールに必要なgem(以下３つ)
  gem 'pry-rails'
  gem 'better_errors'
  gem 'binding_of_caller'
  # RSpecに必要なgem(以下５つ)
  gem 'capybara'
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'rspec-rails'
  gem 'spring-commands-rspec'
  # FeatureSpecのテスト内部で起こっている状態が可視化されるsave_and_open_pageメソッドを使うためのgem
  gem 'launchy'
  # ENVでセキュリティ対策するために必要なgem
  gem 'dotenv-rails'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
