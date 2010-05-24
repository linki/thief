module Thief
  module Wikipedia
    class Person
      include DataMapper::Resource
    
      storage_names[:default] = 'wikipedia_people'

      property :id, Serial   # An auto-increment integer key
    
      property :name, String
      property :alternative_names, String
      property :short_description, String
      property :date_of_birth, String
      property :place_of_birth, String
      property :date_of_death, String
      property :place_of_death, String
    end
  end
end
