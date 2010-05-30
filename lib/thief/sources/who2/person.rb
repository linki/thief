module Thief
  module Who2
    class Person
      include DataMapper::Resource
    
      storage_names[:default] = 'who2_people'

      property :id, Serial   # An auto-increment integer key
    
      property :external_id, String
      property :name, String # Magellan, Ferdinand
      property :profession, String # Magalhães, Fernão de (Portuguese); Magallanes, Fernando de (Spanish)
      property :biography, Text # Sea explorer
      property :extra_credit, Text
      property :date_of_birth, String # 1480
      property :place_of_birth, String # Sabrose, Portugal
      property :death, String # 27 April 1521
      property :best_known_as, String # Mactan Island, Cebu, Philippines
    end
  end
end
