# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://guides.rubygems.org/specification-reference/ for more options
  gem.name = "bixby-api-pool"
  gem.homepage = "https://github.com/chetan/bixby-api-pool"
  gem.license = "MIT"
  gem.summary = %Q{Simple API client pooling library}
  gem.description = %Q{A simple library for pooling API client connections}
  gem.email = "chetan@pixelcop.net"
  gem.authors = ["Chetan Sarva"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require "micron/rake"
Micron::Rake.new do |task|
end
task :default => :test

require 'yard'
YARD::Rake::YardocTask.new
