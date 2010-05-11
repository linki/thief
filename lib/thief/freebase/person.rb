module Thief
  module Wikipedia
    class Person
      include DataMapper::Resource
    
      storage_names[:default] = 'freebase_people'

      property :id, Serial   # An auto-increment integer key
    
      property :name, String # 
      property :external_id, String #
      property :date_of_birth, String # 
      property :place_of_birth, String # 
      property :nationality, String
      property :religion, String
      property :gender, String
      property :meta_web_user_s, String
      property :parents, String
      property :children, String
      property :eployment_history, String
      property :signature, String
      property :spouse_s, String
      property :sibling_s, String
      property :weight_kg, String # maybe Integer
      property :height_meters, String # maybe Integer
      property :education, String
      property :profession, String
      property :quotations, String
      property :places_lived, String
      property :ethnicity, String
      property :quotationsbook_id, String
      property :age, String # maybe Integer
      property :tvrage_id, String
    end
  end
end
