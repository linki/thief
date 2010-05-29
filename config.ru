# This file is used by Rack-based servers to start the application.
require ::File.expand_path('lib/boot', ::File.dirname(__FILE__))

require 'thief'
require 'thief/application'

Thief.setup do |config|
  config.database = ::File.expand_path('config/database.yml', ::File.dirname(__FILE__))
end

run Thief::Application
