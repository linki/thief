module Thief
  class TagLink
    include DataMapper::Resource
    
    storage_names[:default] = 'tag_links'

    property :id, Serial
    property :source_tag_name, String, :length => 255, :index => true
    property :target_tag_name, String, :length => 255, :index => true
    property :count, Integer
        
    def name
      "#{source_tag_name}/#{target_tag_name}"
    end
  end
end
