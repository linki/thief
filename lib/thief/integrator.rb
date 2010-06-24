require 'parsedate' if RUBY_VERSION < '1.9'
require 'date'



module Thief
  class Integrator
    class << self
      attr_accessor :mapping
    
      def map(&block)
        self.mapping = block
      end
      
      def parseDate(dateString)
        if defined?(ParseDate)
          parts = ParseDate.parsedate(dateString)
          begin
            if (parts[0] != nil) # at least a year was found
              return Date.new(*parts.compact)
            end
          rescue ArgumentError => e
            return nil
          end
          return nil
        else
          begin
            GermanDate.parse(dateString) if dateString
          rescue ArgumentError
            nil
          end
        end
      end
      
    end

    def integrate
      rowcount = namespace::Person.count
      init_offset = 1
      if rowcount > 0
        init_offset = namespace::Person.first.id
      end
      offset = init_offset
      limit = 10000
      # we are loading the data in smaller chunks to save memory
      while offset <= rowcount + init_offset
        namespace::Person.all(:limit => limit, :offset => offset).each do |person|
          new_person = ::Thief::Person.new
          # automatic matching
          (namespace::Person.properties.map(&:name) & ::Thief::Person.properties.map(&:name) - [:id]).each do |property|
            content = person.send(property)
            if content && !(content.class == String && content != '')
              new_person.send("#{property}=", namespace::Integrator.clean(property, content))
            end
          end
          new_person.source = self.class.source_name
          self.class.mapping.call(person, new_person) if self.class.mapping
          new_person.save!
        end
        offset = offset + limit
      end
    end
    
    def self.clean(property, content)
      return content
    end
    
  private
    
    def self.source_name
      name.split('::')[1]
    end

    def namespace
      Thief.const_get(self.class.source_name)
    end
  end
end