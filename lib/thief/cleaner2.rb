require 'levenshtein'
require 'date'

module Thief
  class Cleaner2
    
    def weighted_attributes
      return {'last_name' => 0.4, 'first_name' => 0.3, 'profession' => 0.1, 'date_of_birth' => 0.2}
    end
    
    def similarity2(person1, person2)
      sim = 0
      weighted_attributes.each_pair do |key, value|
        if person1.send(key).class == String || person2.send(key).class == String
          sim += value * similarity_string(person1.send(key), person2.send(key))
        elsif person1.send(key).class == Date || person2.send(key).class == Date
          sim += value * similarity_date(person1.send(key), person2.send(key))
        else
          # NilClass, what about text?
        end
      end
      return sim 
    end
    
    def similarity(person1, person2)
      sims = {}
      if person1.last_name || person2.last_name 
        sims['last_name'] = [6, similarity_string(person1.last_name, person2.last_name)]
      sims['first_name'] = [4, similarity_string(person1.first_name, person2.first_name)]
      if person1.date_of_birth && person2.date_of_birth
        sims['date_of_birth'] = [2, similarity_date(person1.date_of_birth, person2.date_of_birth)]
      end
      if person1.place_of_birth && person2.place_of_birth
        
      end
      if person1.profession && person2.profession
        sims['profession'] = [2, similarity_list(person1.profession, person2.profession)]
      end
      sim = 0.0
      weights = 0.0
      sims.each do |weight, s| 
        sim += weight * s
        weights += weight
      end
      return sim / weights
    end
    
    def similarity_list(list1, list2)
      return 1.0
    end
    
    def similarity_date(date1, date2)
      if date1 && date2
        sim_day = 1 - ([31 - date1.day + date2.day, date1.day - date2.day].min / 31.0)
        sim_month = 1 - ([12 - date1.month + date2.month, date1.month - date2.month].min / 12.0)
        sim_year = 0
        return 0.2 * sim_day + 0.3 * sim_month + 0.5 * sim_year
      end
      return 0
    end
    
    def merge(present_person, person)
      present_person.first_name = choose_name(present_person.first_name, person.first_name)
      present_person.last_name = choose_name(present_person.last_name, person.last_name)
      
      present_person.gender = person.gender unless present_person.gender
      present_person.date_of_birth = person.date_of_birth unless present_person.date_of_birth
      present_person.date_of_death = person.date_of_death unless present_person.date_of_death
      
      present_person.biography = merge_bio(present_person.biography, person.biography)
      
      present_person.title = merge_lists(present_person.title, person.title)
      present_person.alternative_name = merge_lists(present_person.alternative_name, person.alternative_name)
      present_person.profession = merge_lists(present_person.profession, person.profession)
      present_person.place_of_birth = merge_lists(present_person.place_of_birth, person.place_of_birth)
      present_person.place_of_death = merge_lists(present_person.place_of_death, person.place_of_death)
      present_person.nationality = merge_lists(present_person.nationality, person.nationality)
      present_person.religion = merge_lists(present_person.religion, person.religion)
      present_person.source = merge_lists(present_person.source, person.source)
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
      puts "#{person.id} - #{present_person.id}: #{similarity(person, present_person)}"
      return similarity(person, present_person) > threshold
    end
    
    def similarity_string(name1, name2)
      if name1 && name2
        return 1 - Levenshtein.normalized_distance(name1, name2)
      end
      return 0
    end
    
    def merge_lists(list1, list2)
      if list1 && list2
        result = list1.split(', ')
        list2.split(', ').each do |new_elem|
          list1.split(', ').each do |old_elem|
            if similarity_string(new_elem, old_elem) < 0.9
              result.push new_elem
            end
          end
        end
        return result.join(', ')
      elsif list1
        return list1
      elsif list2
        return list2
      end
      return nil
    end
    
    def choose_name(name1, name2)
      if name1 && name2
        if name1.length > name2.length
          return name1
        else
          return name2
        end
      elsif name1
        return name1
      elsif name2
        return name2
      end
      return nil
    end
    
    def merge_bio(bio1, bio2)
      if bio1 && bio2
        if bio1 != bio2
          bio1 += " #{bio2}"
        end
        return bio1
      elsif bio1
        return bio1
      elsif bio2
        return bio2
      end
      return nil
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