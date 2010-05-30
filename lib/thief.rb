# require all *.rb files in support folder (/lib/thief/support/*.rb)
Dir[File.expand_path('thief/support/*.rb', File.dirname(__FILE__))].each {|f| require f}

require 'dm-core'
require 'thief/core_ext/dm-core/model'

require 'thief/source'

require 'thief/etl'
require 'thief/integrator'
require 'thief/person'

# require all *.rb files in sources folder (/lib/thief/sources/*.rb)
Dir[File.expand_path('thief/sources/*.rb', File.dirname(__FILE__))].each {|f| require f}

module Thief
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
    DataMapper::Logger.new(STDOUT, $DEBUG ? :debug : :error)
  end
  
  def database=(db_config)
    unless db_config =~ /:\/\//
      require 'yaml'
      db_config = YAML.load_file(db_config)[Thief.env]
    end  

    DataMapper.setup(:default, db_config)    
  end

  def setup(db_config = nil)
    configure
    self.database = db_config if db_config
    yield self if block_given?
  end
  
  def env
    ENV['RACK_ENV'] ||= ENV['THIEF_ENV'] ||= 'development'
  end    
  
  def create_tables
    DataMapper.auto_migrate!
  end
  
  def tmp_dir
    File.expand_path('../tmp', File.dirname(__FILE__))
  end
  
  extend self
end

Bundler.require(:default, Thief.env) if defined?(Bundler)