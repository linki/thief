module Thief
  Tags = /<.*?>/
  module Who2
    class Integrator < Thief::Integrator
      map do |source, target|
        parts = source.name.split(/,\s*/)
        if (parts.length > 1)
          target.last_name = parts[0]
          target.first_name = parts[1]
          if (parts.length > 2)
            target.title = parts[2]
          end
        else
          if (mName = source.name.match(Thief::Nobility))
            parts = source.name.split(Thief::Nobility, 2)
            target.first_name = (parts[0] + ' ' + parts[1]).strip
            target.last_name = parts[2].strip
          else
            target.first_name = source.name
          end
        end
        if source.best_known_as
          target.alternative_name = source.best_known_as.gsub(Tags, '')
        end
        target.profession = source.profession.gsub(/\s\//, ',')
        if source.biography and source.extra_credit
          target.biography = source.biography.gsub(Tags, '') + " \nExtra Credit: " + source.extra_credit.gsub(Tags, '')
        else
          if source.biography
            target.biography = source.biography.gsub(Tags, '')
          else
            if source.extra_credit
              target.biography = source.extra_credit.gsub(Tags, '')
            end
          end
        end
        if source.date_of_birth
          target.date_of_birth = parseDate(source.date_of_birth.gsub(/<br\s*?\/>.*$/, '').strip)
        end
        if source.place_of_birth
          target.place_of_birth = source.place_of_birth.gsub(Tags, '')
        end
        if source.death
          target.date_of_death = parseDate(source.death.gsub(/<br\s*?\/>.*$/, '').strip)
        end
      end
    end
  end
end