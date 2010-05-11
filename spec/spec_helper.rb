require 'rubygems' if RUBY_VERSION < '1.9'
require 'bundler'
Bundler.setup

$:.unshift File.expand_path('../../lib', __FILE__)
require 'thief'