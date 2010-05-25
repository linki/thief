module Thief
  class Integrator
    class << self
      attr_accessor :mapping
    
      def map(&block)
        mapping = block
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

    def source_name
      self.class.name.split('::')[1]
    end

    def namespace
      Thief.const_get(source_name)
    end
  end
end