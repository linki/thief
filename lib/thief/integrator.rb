module Thief
  class Integrator
    class << self
      attr_accessor :mapping
    
      def map(&block)
        self.mapping = block
      end
    end
    
    def integrate
      namespace::Person.all.each do |person|
        new_person = ::Thief::Person.new
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