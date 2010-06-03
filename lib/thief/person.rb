module Thief
  class Person
    include DataMapper::Resource
    
    storage_names[:default] = 'people'

    property :id, Serial   # An auto-increment integer key

    property :title, String   # A varchar type string, for short strings        
    property :first_name, String   # A varchar type string, for short strings
    property :last_name,  String   # A varchar type string, for short strings
    property :alternative_name, String
    property :gender, String
    property :birthdate, Date
    property :birthplace, String
    property :date_of_death, Date
    property :place_of_death, String
    property :biography, Text
    property :profession, String
    property :nationality, String
    property :religion, String

    def name
      [first_name, last_name].compact.join(' ')
    end    

    def full_name
      [title, name].compact.join(' ')
    end    
  end
end
