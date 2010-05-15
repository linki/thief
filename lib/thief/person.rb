module Thief
  class Person
    include DataMapper::Resource
    
    storage_names[:default] = 'people'

    property :id, Serial   # An auto-increment integer key
    
    property :first_name, String   # A varchar type string, for short strings
    property :last_name,  String   # A varchar type string, for short strings
    
    def self.delete_all
      DataMapper.repository.delete(self.all)
    end

    def name
      [first_name, last_name].join(' ')
    end    
  end
end
