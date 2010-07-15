module Thief
  class Tag
    include DataMapper::Resource
    
    storage_names[:default] = 'tags'

    property :id, Serial

    property :name, String, :length => 255, :index => true
    property :count, Integer
  end
end
