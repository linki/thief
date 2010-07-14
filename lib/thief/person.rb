module Thief
  class Person
    include DataMapper::Resource
    
    storage_names[:default] = 'people'

    property :id, Serial   # An auto-increment integer key

    property :title, String, :length => 255 # A varchar type string, for short strings        
    property :first_name, String, :length => 255   # A varchar type string, for short strings
    property :last_name,  String, :length => 255   # A varchar type string, for short strings
    property :alternative_name, String, :length => 255
    property :gender, String, :length => 255
    property :date_of_birth, Date
    property :place_of_birth, String, :length => 255
    property :date_of_death, Date
    property :place_of_death, String, :length => 255
    property :biography, Text
    property :profession, String, :length => 255
    property :nationality, String, :length => 255
    property :religion, String, :length => 255
    property :source, String, :length => 255
    property :neighbour_key, String, :length => 255, :required => true, :index => true
    
    before :valid?, :generate_neighbour_key

    def generate_neighbour_key(context = :default)
      if last_name || first_name
        self.neighbour_key = last_name ? last_name[0..2].downcase : '+++'
        (3 - self.neighbour_key.length).times {self.neighbour_key += '+'}
        self.neighbour_key += first_name ? first_name[0..2].downcase : '+++'
        (6 - self.neighbour_key.length).times {self.neighbour_key += '+'}
      end
    end
    
    def name
      [first_name, last_name].compact.join(' ')
    end    

    def full_name
      [title, name].compact.join(' ')
    end    
  end
end
