module Thief
  module IMDb
    class Person
      include DataMapper::Resource
    
      storage_names[:default] = 'imdb_people'

      property :id, Serial   # An auto-increment integer key

      property :first_name, String    # George
      property :last_name,  String    # Clooney
    end
  end
end
