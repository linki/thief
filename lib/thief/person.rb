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
    property :date_of_birth, Date
    property :place_of_birth, String
    property :date_of_death, Date
    property :place_of_death, String
    property :biography, Text
    property :profession, String
    property :nationality, String
    property :religion, String
    property :source, String
    property :neighbour_key, String, :required => true
    
    before :valid?, :generate_neighbour_key

    def generate_neighbour_key(context = :default)
      if last_name || first_name
        self.neighbour_key = last_name ? last_name[0..2].downcase : '+++'
        self.neighbour_key += first_name ? first_name[0..2].downcase : '+++'
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
