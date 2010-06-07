require 'date'

module Thief
  Titles = /^(Dr\. h\. c\. |Prof\. Dr\. |Dr\. |Prof\. )/
  
  module DAPI
    class Integrator < Thief::Integrator
      map do |source, target|
        target.first_name     = source.vorname
        target.last_name      = source.nachname
        target.date_of_birth  = source.geboren_am # automatic parsing
        target.place_of_birth = source.geboren_ort
        target.biography      = source.biografie
        target.profession     = source.jobs
        target.religion       = source.religion

        # if a title is present in vorname, split it
        if match_data = Thief::Titles.match(target.first_name)
          target.title = match_data.to_s.strip
          target.first_name = match_data.post_match.strip
        end
      end
    end
  end
end