module Thief
  Nobility = /\s+(von|de|di|van|d’)\s+/
  Clean = /(^\s+|\[|\]|\s+$)/
  module Wikipedia
    class Integrator < Thief::Integrator
      map do |source, target|
        parts = source.name.gsub(Clean, '').split(/,\s*/)
        if (parts.length > 1)
          target.last_name = parts[0]
          target.first_name = parts[1]
          if (parts.length > 2)
            target.title = parts[2]
          end
        else
          if (mName = source.name.gsub(Clean, '').match(Nobility))
            parts = (source.name.gsub(Clean, '')).split(Nobility, 2)
            target.first_name = (parts[0] + ' ' + parts[1]).strip
            target.last_name = parts[2].strip
          else
            target.first_name = source.name.gsub(Clean, '')
          end
        end
        if (source.alternative_names != nil)
          target.alternative_name = source.alternative_names.gsub(Clean, '')
        end
        if (source.short_description != nil)
          target.biography = source.short_description.gsub(Clean, '')
        end
        if (source.date_of_birth != nil)
          target.birthdate = parseDate(source.date_of_birth.gsub(Clean, ''))
        end
        if (source.place_of_birth != nil)
          target.birthplace = source.place_of_birth.gsub(Clean, '')
        end
        if (source.date_of_death != nil)
          target.date_of_death = parseDate(source.date_of_death.gsub(Clean, ''))
        end
        if (source.place_of_death != nil)
          target.place_of_death = source.place_of_death.gsub(Clean, '')
        end
        target.source = 'Wikipedia'
          
      end
    end
  end
end