# require all *.rb files in support folder (/lib/thief/support/*.rb)
Dir[File.expand_path('../thief/support/*.rb', __FILE__)].each {|f| require f}

require 'dm-core'

require 'thief/etl'
require 'thief/integrator'
require 'thief/person'

# require all etl.rb files in subfolders (/lib/thief/**/etl.rb)
Dir[File.expand_path('../thief/**/etl.rb', __FILE__)].each {|f| require f}

# require all integrator.rb files in subfolders (/lib/thief/**/etl.rb)
Dir[File.expand_path('../thief/**/integrator.rb', __FILE__)].each {|f| require f}

# require all person.rb files in subfolders (/lib/thief/**/etl.rb)
Dir[File.expand_path('../thief/**/person.rb', __FILE__)].each {|f| require f}

module Thief
  class << self
    def fetch
      ETL.children.each do |etl|
        etl.fetch if etl.enabled?
      end
    end
  
    def integrate
      Integrator.children.each do |integrator|
        integrator.integrate if integrator.enabled?
      end
    end
    
    def configure
      DataMapper::Logger.new($stdout, :debug)
    end
  
    def setup
      configure
      
      # An in-memory Sqlite3 connection:
      # DataMapper.setup(:default, 'sqlite3::memory:')
    
      # Sqlite3 connection:
      DataMapper.setup(:default, 'sqlite3:db/thief.sqlite3')

      # A MySQL connection:
      # DataMapper.setup(:default, 'mysql://localhost/person_test')

      # A Postgres connection:
      # DataMapper.setup(:default, 'postgres://localhost/person_test')    
    end
    
    def create_tables
      setup
      DataMapper.auto_migrate!
    end
    
    def cache_dir
      File.expand_path('../../tmp/cache', __FILE__)
    end
  end
end