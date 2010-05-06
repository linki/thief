require 'dm-core'

require 'thief/person'

module Thief
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