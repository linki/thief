require 'levenshtein'

module Thief
  class Cleaner

    def find_duplicates
      rowcount = Thief::Person.count
      offset = 0
      limit = 10
      window = []
      treshold = 0.9
      while offset <= rowcount
        Thief::Person.all(:limit => limit, :offset => offset, :order => [:neighbour_key]).each do |person|
          merged = false
          window.each do |elem|
            puts "#{elem.id} - #{person.id} - #{measure_similarity(elem, person)}"
            if measure_similarity(elem, person) > treshold
              merge(elem, person)
              merged = true
              break
            end
          end
          if !merged
            if window.size == limit
              window.shift.save
            end
            window.push(person)
          end
          
        end
        offset = offset + limit
      end
      window.each {|elem| elem.save}
    end
    
    def measure_similarity(person1, person2)
      return 0.5 * similarity_string(person1.last_name, person2.last_name) 
              + 0.5 * similarity_string(person1.first_name, person2.first_name)
    end
    
    def similarity_string(name1, name2)
      if name1 && name2
        return 1 - Levenshtein.normalized_distance(name1, name2)
      end
      return 0
    end
    
    def merge(person1, person2)
      @counter += 1
      @duplicates.push([person1, person2])
      person2.destroy
      #Thief.logger.debug "Duplicate: #{person1} <-> #{person2}"
      # TODO: merge values of person2 into person1 and delete person2

    end
    
    def cleanup
      @counter = 0
      @duplicates = []
      find_duplicates
      @duplicates.each do |container| 
        Thief.logger.debug "Duplicate: #{container[0]} <-> #{container[1]}"
      end
      
    end
    
  end
end