require File.expand_path('lib/boot', File.dirname(__FILE__))
require 'thief'

module Thief
  class Db < Thor
    desc "create_tables --env ENVIRONMENT --adapter ADAPTER", "create the database schema for specific environment and database adapter"
    method_options %w( env -e ) => ::Thief.env, %w( adapter -a ) => ::Thief.db_adapter
    def create_tables
      ENV['THIEF_ENV']        ||= options[:environment]
      ENV['THIEF_DB_ADAPTER'] ||= options[:adapter]
      
      ::Thief.setup do |config|
        config.database = File.expand_path('config/database.yml', File.dirname(__FILE__))
      end
      
      ::Thief.create_tables
    end  
  end
end