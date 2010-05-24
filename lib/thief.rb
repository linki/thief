# require all *.rb files in support folder (/lib/thief/support/*.rb)
Dir[File.expand_path('../thief/support/*.rb', __FILE__)].each {|f| require f}

require 'dm-core'
require 'thief/core_ext/dm-core/model'

require 'thief/source'

require 'thief/etl'
require 'thief/integrator'
require 'thief/person'

# require all *.rb files in sources
Dir[File.expand_path('../thief/sources/*.rb', __FILE__)].each {|f| require f}

module Thief
  class << self
    attr_writer :sources
    
    def sources
      @sources ||= []
    end
    
    def fetch
      sources.each(&:fetch)
    end
  
    def integrate
      sources.each(&:integrate)
    end
    
    def configure
      DataMapper::Logger.new(STDOUT, :debug)
    end
  
    def setup(db_config)
      configure
      
      unless db_config =~ /:\/\//
        require 'yaml'
        db_config = YAML.load_file(db_config)[Thief.env]
      end  

      DataMapper.setup(:default, db_config)
    end
    
    def env
      ENV['THIEF_ENV'] ||= 'development'
    end    
    
    def create_tables
      DataMapper.auto_migrate!
    end
    
    def tmp_dir
      File.expand_path('../../tmp', __FILE__)
    end
  end
end