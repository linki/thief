module Thief
  class Person
    include DataMapper::Resource
    
    storage_names[:default] = 'people'

    property :id,        Serial   # An auto-increment integer key
    property :name,      String   # A varchar type string, for short strings
  end
end
