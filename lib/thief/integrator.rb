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
        end
      end
      
    end
    
    def integrate
      namespace::Person.all.each do |person|
        new_person = ::Thief::Person.new
        new_person.source = self.class.source_name
        self.class.mapping.call(person, new_person)
        new_person.save!
      end
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