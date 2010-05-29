ENV['RACK_ENV'] ||= ENV['THIEF_ENV'] ||= 'test'
require File.expand_path('../lib/boot', File.dirname(__FILE__))

require 'thief'

Thief.setup do |config|
  config.database = File.expand_path('../config/database.yml', File.dirname(__FILE__))
end

# Thief.create_tables