require 'rubygems'
# Set up gems listed in the Gemfile.
if File.exist?(File.expand_path('../../Gemfile', __FILE__))
  require 'bundler'
  Bundler.setup
end

$:.unshift File.expand_path('..', __FILE__)

$KCODE = 'u' if RUBY_VERSION < '1.9'