require 'rubygems'
# Set up gems listed in the Gemfile.
if File.exist?(File.expand_path('../Gemfile', File.dirname(__FILE__)))
  require 'bundler'
  Bundler.setup
end

$:.unshift File.expand_path(File.dirname(__FILE__))

$KCODE = 'u' if RUBY_VERSION < '1.9'

require 'optparse'
OptionParser.new do |opts|
  opts.on('-a', '--adapter ADAPTER', 'Change the database adapter') { |adapter| ENV['THIEF_DB_ADAPTER'] = adapter }
  opts.on('-d', '--debug', 'Turn on Debug Mode') { $DEBUG = true }
  opts.on('-e', '--environment ENV', 'Change the environment') { |env| ENV['THIEF_ENV'] = env }
end.parse!