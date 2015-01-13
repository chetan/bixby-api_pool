source "https://rubygems.org"

gem "actionpool", "~> 0.2"
gem "net-http-persistent"

group :development do
  gem "bundler", "~> 1.0"
  gem "jeweler", "~> 2.0.1"
  gem "yard", "~> 0.7"
  gem "pry", "~> 0.9"

  gem "test_guard", '~> 0.2.0', :github => "chetan/test_guard"
  gem 'rb-inotify', '~> 0.9.2', :require => false
  gem 'rb-fsevent', '~> 0.9.3', :require => false
  gem 'rb-fchange', '~> 0.0.6', :require => false
end

group :test do
  gem "micron",  "~> 0.5.0", :github => "chetan/micron"
  gem "easycov", "~> 0.4.0", :github => "chetan/easycov"

  # gem "webmock", "~> 1.14.0", :require => false
  # gem "mocha", "~> 0.14.0", :require => false
  gem "sinatra", "~> 1.4"
  gem "puma"
end
