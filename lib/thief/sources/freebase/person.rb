module Thief
  module Freebase
    class Person
      include DataMapper::Resource
    
      storage_names[:default] = 'freebase_people'

      property :id, Serial   # An auto-increment integer key
    
      property :name, String, :length => 255 # 
      property :external_id, String, :length => 255 #
      property :date_of_birth, String, :length => 255 # 
      property :place_of_birth, String, :length => 255 # 
      property :nationality, String
      property :religion, String, :length => 255
      property :gender, String, :length => 255
      property :meta_web_user_s, String, :length => 255
      property :parents, String, :length => 255
      property :children, String, :length => 255
      property :employment_history, String, :length => 255
      property :signature, String, :length => 255
      property :spouse_s, String, :length => 255
      property :sibling_s, String, :length => 255
      property :weight_kg, String, :length => 255 # maybe Integer
      property :height_meters, String, :length => 255 # maybe Integer
      property :education, String, :length => 255
      property :profession, String, :length => 255
      property :quotations, String, :length => 255
      property :places_lived, String, :length => 255
      property :ethnicity, String, :length => 255
      property :quotationsbook_id, String, :length => 255
      property :age, String, :length => 255 # maybe Integer
      property :tvrage_id, String, :length => 255
    end
  end
end
