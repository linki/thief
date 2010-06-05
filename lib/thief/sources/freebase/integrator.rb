module Thief
  module Freebase
    class Integrator < Thief::Integrator
      map do |source, target|
        parts = source.name.split
        if parts.length > 1
          target.last_name = parts.last
          target.first_name = parts[0..parts.length - 2].join(' ')
        else
          target.first_name = source.name
        end
        if source.date_of_birth
          target.birthdate = parseDate(source.date_of_birth)
        end
        if source.place_of_birth
          target.birthplace = source.place_of_birth
        end
        target.nationality = source.nationality
        target.religion = source.religion
        target.gender = source.gender
        target.profession = source.profession
        target.source = 'Freebase'
      end
    end
  end
end