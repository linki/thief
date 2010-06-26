module Thief
  module Wikipedia
    class Person
      include DataMapper::Resource
    
      storage_names[:default] = 'wikipedia_people'

      property :id, Serial   # An auto-increment integer key
    
      property :name, String, :length => 255 # Magellan, Ferdinand
      property :alternative_names, String, :length => 255 # Magalhães, Fernão de (Portuguese); Magallanes, Fernando de (Spanish)
      property :short_description, String, :length => 255 # Sea explorer
      property :date_of_birth, String, :length => 255 # 1480
      property :place_of_birth, String, :length => 255 # Sabrose, Portugal
      property :date_of_death, String, :length => 255 # 27 April 1521
      property :place_of_death, String, :length => 255 # Mactan Island, Cebu, Philippines
    end
  end
end
