require 'levenshtein'

module Thief
  class Cleaner

    def find_duplicates
      rowcount = Thief::Person.count
      offset = 1
      limit = 100
      queue = []
      treshold = 0.9
      while offset <= rowcount
        Thief::Person.all(:limit => limit, :offset => offset, :order => [:neighbour_key]).each do |person|
          merged = false
          queue.each do |elem|
            if measure_similarity(elem, person) > treshold
              merge(elem, person)
              merged = true
              break
            end
          end
          if !merged
            if queue.size == limit
              queue.shift
            end
            queue.push(person)
          end
          
        end
        offset = offset + limit
      end
    end
    
    def measure_similarity(person1, person2)
      sim_last_name = 0
      sim_first_name = 0
      
      return 0.0
    end
    
    def merge(person1, person2)
      @counter += 1
      @duplicates.push = [person1, person2]
      # TODO: merge values of person2 into person1 and delete person2
    end
    
    def cleanup
      @counter = 0
      @duplicates = []
      find_duplicates
      @duplicates.each do |container| 
        Thief.logger.debug "Duplicate: #{container[0]} <-> container[1]"
      end
      
    end
    
  end
end