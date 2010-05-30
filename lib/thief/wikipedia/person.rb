module Thief
  module Wikipedia
    class Person
      include DataMapper::Resource
    
      storage_names[:default] = 'wikipedia_people'

      property :id, Serial   # An auto-increment integer key
    
      property :name, String # Magellan, Ferdinand
      property :alternative_names, String # Magalhães, Fernão de (Portuguese); Magallanes, Fernando de (Spanish)
      property :short_description, String # Sea explorer
      property :date_of_birth, String # 1480
      property :place_of_birth, String # Sabrose, Portugal
      property :date_of_death, String # 27 April 1521
      property :place_of_death, String # Mactan Island, Cebu, Philippines
    end
  end
end
