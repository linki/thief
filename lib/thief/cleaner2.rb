require 'levenshtein'

module Thief
  class Cleaner2
    
    def similarity(person1, person2)
      return 0.5 * similarity_string(person1.last_name, person2.last_name) +
             0.5 * similarity_string(person1.first_name, person2.first_name)
    end
    
    def merge(present_person, person)
      present_person.gender = person.gender unless present_person.gender
    end

    def cleanup
      window = []
      runs = (Thief::Person.count / batch_size).ceil
      (0..runs).each do |run|
        Thief::Person.all(:offset => run * batch_size, :limit => batch_size, :order => [:id]).each do |person|
          if present_person = already_present?(person, window)
            merge(present_person, person)
            present_person.save          
            person.destroy
          else
            window.push person
            window.shift if window.size > window_size
          end
        end
      end
    end    

  private
  
    def already_present?(person, window)
      window.each do |present_person|
        return present_person if similar?(person, present_person)
      end
      false
    end
    
    def similar?(person, present_person)
      return similarity(person, present_person) > threshold
    end
    
    def similarity_string(name1, name2)
      if name1 && name2
        return 1 - Levenshtein.normalized_distance(name1, name2)
      end
      return 0
    end
    
    def threshold
      0.8
    end
    
    def batch_size
      1000
    end
    
    def window_size
      100
    end
        
  end
end