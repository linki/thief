require 'json'
require 'uri'
require 'open-uri'
require 'net/http'

module Thief
  GEOSERVICE = 'http://maps.google.com/maps/api/geocode/'
  RETURNTYPE = 'json'
  LANGUAGE = 'en'
  
  class GeoCoder

    def geocode
      run
    end
    
  private
  
    def lookup(location)
      response = open("#{GEOSERVICE}#{RETURNTYPE}?address=#{encode_location(location)}&language=#{LANGUAGE}&sensor=false").read
      return JSON.parse(response)
    end

    def encode_location(location)
      URI.encode(location.split.join('+'))
    end

    def copy_content(old_person, new_person)
      
    end

    def run
      Thief::Person.all(:place_of_birth.not => nil, :profession.not => nil, :date_of_birth.not => nil).each do |person|
        response = lookup(person.place_of_birth)
        if response['status'] == 'OK' and response['results'].size > 0
          new_person = Thief::GeoPerson.new
          copy_content(person, new_person)
          new_person.place_of_birth = response['results'][0]['formatted_address']
          new_person.save
        else 
          Thief.logger.error "#{response['status']} - Couldn't geocode: #{person.place_of_birth}"
        end
      end
    end
  end
end