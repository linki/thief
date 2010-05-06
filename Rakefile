require 'rubygems' if RUBY_VERSION < '1.9'
require 'bundler'
Bundler.setup

require 'rake'

$:.push File.expand_path('../lib', __FILE__)
require 'thief'

# task :default => :test

namespace :thief do
  task :create_tables do
    Thief.create_tables!
  end
end