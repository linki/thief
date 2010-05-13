require 'rubygems'
require 'bundler'
Bundler.setup

require 'rake'

$:.unshift File.expand_path('../lib', __FILE__)
require 'thief'

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec)
task :default => :spec

namespace :thief do
  task :create_tables do
    Thief.create_tables
  end
end