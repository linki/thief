module Thief
  class Integrator
    def self.mappings
      @mappings ||= [] 
    end

    def self.map(mapping, &block)
      mappings << [mapping.keys.first, mapping.values.first, block || proc { |source| source }]
    end
    
    def integrate
      namespace::Person.all.each do |person|
        new_person = ::Thief::Person.new
        self.class.mappings.each do |mapping|
          source_value = person.send(mapping[0])
          target_value = mapping[2].call(source_value)
          new_person.send("#{mapping[1]}=", target_value)
        end
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