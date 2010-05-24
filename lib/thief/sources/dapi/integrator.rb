module Thief
  Titles = /^Dr\. / #|h\. c\. |Prof\. |Prof\. Dr\. ]/
  
  module DAPI
    class Integrator < Thief::Integrator
      map :vorname  => :first_name do |vorname|
        match_data = Thief::Titles.match(vorname)
        match_data ? match_data.post_match.strip : vorname
      end
      map :vorname  => :title do |vorname|
        match_data = Thief::Titles.match(vorname)
        match_data ? match_data.to_s.strip : nil
      end
      map :nachname => :last_name
    end
  end
end