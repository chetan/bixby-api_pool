
require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'micron/minitest'
# require 'webmock'
# require 'mocha/setup'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'bixby-api_pool'

require "base"
require "support/webserver"

Dir.glob(File.dirname(__FILE__) + "/../lib/**/*.rb").each{ |f| require f }
