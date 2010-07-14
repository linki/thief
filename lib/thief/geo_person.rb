module Thief
  class GeoPerson
    include DataMapper::Resource
    
    storage_names[:default] = 'geo_people'
    
    property :id, Serial
    property :title, String, :length => 255 # A varchar type string, for short strings        
    property :first_name, String, :length => 255   # A varchar type string, for short strings
    property :last_name,  String, :length => 255   # A varchar type string, for short strings
    property :alternative_name, String, :length => 255
    property :gender, String, :length => 255
    property :date_of_birth, Date
    property :place_of_birth, String, :length => 255
    property :country, String, :length => 255
    property :country_code, String, :length => 255
    property :latitude, Decimal, :precision => 13, :scale => 10
    property :longitude, Decimal, :precision => 13, :scale => 10
    property :date_of_death, Date
    property :place_of_death, String, :length => 255
    property :biography, Text
    property :profession, String, :length => 255
    property :nationality, String, :length => 255
    property :religion, String, :length => 255
    property :source, String, :length => 255
    
  end
end