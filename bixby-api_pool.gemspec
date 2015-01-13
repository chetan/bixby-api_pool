# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: bixby-api_pool 0.2.0 ruby lib

Gem::Specification.new do |s|
  s.name = "bixby-api_pool"
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Chetan Sarva"]
  s.date = "2015-01-13"
  s.description = "A simple library for pooling API client connections"
  s.email = "chetan@pixelcop.net"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    ".testguardrc",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.md",
    "Rakefile",
    "VERSION",
    "bixby-api_pool.gemspec",
    "lib/bixby-api_pool.rb",
    "lib/bixby/api_pool.rb",
    "lib/bixby/api_pool/request.rb",
    "lib/bixby/api_pool/response.rb",
    "test/base.rb",
    "test/helper.rb",
    "test/support/app.rb",
    "test/support/server.rb",
    "test/test_pool.rb"
  ]
  s.homepage = "https://github.com/chetan/bixby-api_pool"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.2"
  s.summary = "Simple API client pooling library"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<actionpool>, ["~> 0.2"])
      s.add_runtime_dependency(%q<net-http-persistent>, [">= 0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 2.0.1"])
      s.add_development_dependency(%q<yard>, ["~> 0.7"])
      s.add_development_dependency(%q<pry>, ["~> 0.9"])
      s.add_development_dependency(%q<test_guard>, ["~> 0.2.0"])
      s.add_development_dependency(%q<rb-inotify>, ["~> 0.9.2"])
      s.add_development_dependency(%q<rb-fsevent>, ["~> 0.9.3"])
      s.add_development_dependency(%q<rb-fchange>, ["~> 0.0.6"])
    else
      s.add_dependency(%q<actionpool>, ["~> 0.2"])
      s.add_dependency(%q<net-http-persistent>, [">= 0"])
      s.add_dependency(%q<bundler>, ["~> 1.0"])
      s.add_dependency(%q<jeweler>, ["~> 2.0.1"])
      s.add_dependency(%q<yard>, ["~> 0.7"])
      s.add_dependency(%q<pry>, ["~> 0.9"])
      s.add_dependency(%q<test_guard>, ["~> 0.2.0"])
      s.add_dependency(%q<rb-inotify>, ["~> 0.9.2"])
      s.add_dependency(%q<rb-fsevent>, ["~> 0.9.3"])
      s.add_dependency(%q<rb-fchange>, ["~> 0.0.6"])
    end
  else
    s.add_dependency(%q<actionpool>, ["~> 0.2"])
    s.add_dependency(%q<net-http-persistent>, [">= 0"])
    s.add_dependency(%q<bundler>, ["~> 1.0"])
    s.add_dependency(%q<jeweler>, ["~> 2.0.1"])
    s.add_dependency(%q<yard>, ["~> 0.7"])
    s.add_dependency(%q<pry>, ["~> 0.9"])
    s.add_dependency(%q<test_guard>, ["~> 0.2.0"])
    s.add_dependency(%q<rb-inotify>, ["~> 0.9.2"])
    s.add_dependency(%q<rb-fsevent>, ["~> 0.9.3"])
    s.add_dependency(%q<rb-fchange>, ["~> 0.0.6"])
  end
end

