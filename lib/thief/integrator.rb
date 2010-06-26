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
      first_offset = 1
      last_offset = 0
      if namespace::Person.count > 0
        first_offset = namespace::Person.first.id
        last_offset = namespace::Person.last.id
      end
      offset = first_offset
      limit = 10000
      Thief.logger.debug "first offset #{first_offset}, last offset #{last_offset}"
      while offset <= last_offset
        namespace::Person.all(:limit => limit, :offset => offset).each do |person|
          new_person = ::Thief::Person.new
          # automatic matching
          Thief.logger.debug person.id
          (namespace::Person.properties.map(&:name) & ::Thief::Person.properties.map(&:name) - [:id]).each do |property|
            content = person.send(property)
            if content && !(content.class == String && content == '')
              if ['date_of_birth', 'date_of_death'].include? property
                new_person.send("#{property}=", Thief.parseDate(namespace::Integrator.clean(property, content)))
              else  
                new_person.send("#{property}=", namespace::Integrator.clean(property, content))
              end
            end
          end
          new_person.source = self.class.source_name
          self.class.mapping.call(person, new_person) if self.class.mapping
          if !new_person.valid?
            Thief.logger.debug new_person.errors
          end 
          if !new_person.save
            Thief.logger.debug "values: #{new_person.first_name} #{new_person.last_name} #{new_person.neighbour_key}"
          end
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