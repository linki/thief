module Thief
  module Who2
    class Person
      include DataMapper::Resource
    
      storage_names[:default] = 'who2_people'

      property :id, Serial   # An auto-increment integer key
    
      property :external_id, String, :length => 255
      property :name, String, :length => 255 # Magellan, Ferdinand
      property :profession, String, :length => 255 # Magalhães, Fernão de (Portuguese); Magallanes, Fernando de (Spanish)
      property :biography, Text # Sea explorer
      property :extra_credit, Text
      property :date_of_birth, String, :length => 255 # 1480
      property :place_of_birth, String, :length => 255 # Sabrose, Portugal
      property :death, String, :length => 255 # 27 April 1521
      property :best_known_as, String, :length => 255 # Mactan Island, Cebu, Philippines
    end
  end
end
