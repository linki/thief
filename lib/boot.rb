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
  opts.on('-d', '--debug', 'Turn on Debug Mode') { $DEBUG = true }
end.parse!
