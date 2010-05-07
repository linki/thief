require 'dm-core'

require 'thief/etl'
require 'thief/integrator'
require 'thief/person'

# require all etl.rb files in subfolders (/lib/thief/**/etl.rb)
Dir["#{File.dirname(__FILE__)}/thief/**/etl.rb"].each {|f| require f}

# require all integrator.rb files in subfolders (/lib/thief/**/etl.rb)
Dir["#{File.dirname(__FILE__)}/thief/**/integrator.rb"].each {|f| require f}

# require all person.rb files in subfolders (/lib/thief/**/etl.rb)
Dir["#{File.dirname(__FILE__)}/thief/**/person.rb"].each {|f| require f}

module Thief
  def self.fetch(arguments)
    Person.all.destroy
    ETL.children.each do |child|
      child.fetch(arguments)
    end
  end
  
  def self.integrate!
    Integrator.children.each do |child|
      child.integrate!
    end 
  end
  
  def self.setup!
    DataMapper::Logger.new($stdout, :debug)
    connect!
    
    # check for tables
  end
  
  def self.connect!
    # An in-memory Sqlite3 connection:
    # DataMapper.setup(:default, 'sqlite3::memory:')
    
    # Sqlite3 connection:
    DataMapper.setup(:default, 'sqlite3:db/thief.sqlite3')

    # A MySQL connection:
    # DataMapper.setup(:default, 'mysql://localhost/person_test')

    # A Postgres connection:
    # DataMapper.setup(:default, 'postgres://localhost/person_test')    
  end
    
  def self.create_tables!
    setup!
    DataMapper.auto_migrate!
  end
end