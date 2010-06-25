module Thief
  class PersonHash
    include DataMapper::Resource
    
    storage_names[:default] = 'person_hashes'
    
    property :id, Serial
    property :value, String
    
    belongs_to :person, 'Thief::Person'
  end
end