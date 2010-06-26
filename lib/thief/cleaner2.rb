module Thief
  class Cleaner2
        
    def weights
      { :first_name => 0.5, :last_name  => 0.5 }
    end
    
    def merge(present_person, person)
      # fill empty properties      
      (Thief::Person.properties.map(&:name) - [:id]).each do |property|
        present_person.send("#{property}=", person.send(property)) unless present_person.send(property)
      end
    end

    def cleanup
      window, runs = [], (Thief::Person.count / batch_size).ceil
      (0..runs).each do |run|
        Thief::Person.all(:offset => run * batch_size, :limit => batch_size, :order => [:neighbour_key]).each do |person|
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

    def string_similarity(name1, name2)
      (name1 && name2) ? 1 - Levenshtein.normalized_distance(name1, name2) : 0
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

    def similarity(person1, person2)
      weights.inject(0) do |sum, weight|
        sum += weight[1] * attribute_similarity(person1.send(weight[0]), person2.send(weight[0]), :string) # person1.send(weight[0]).class.to_s.downcase.to_sym
      end
    end

    def attribute_similarity(name1, name2, type)
      send("#{type}_similarity", name1, name2)
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