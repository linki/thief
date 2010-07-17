require 'json'
require 'uri'
require 'open-uri'
require 'net/http'
require 'socket'

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
      over_quota = false
      count = 0
      loop do
        begin
          response = JSON.parse(open("#{GEOSERVICE}#{RETURNTYPE}?address=#{encode_location(location)}&language=#{LANGUAGE}&sensor=false").read)
        rescue => e
          sleep(10)
        else 
          if response['status'] == 'OK'
            if over_quota
              Thief.logger.error "Continuing Geocoding" 
              over_quota = false
            end
            return response['results'][0]
          elsif response['status'] == 'OVER_QUERY_LIMIT'
            if count == 5
              Thief.logger.error "Quota exceeded, change your IP"
              over_quota = true
            end
            count += 1
            sleep(1)
          else
            Thief.logger.error "#{response['status']} - Couldn't geocode: #{location}"
            return nil
          end
        end
      end
    end

    def encode_location(location)
      URI.encode(location.split.join('+'))
    end

    def copy_old_content(old_person, new_person)
      [:title, :first_name, :last_name, :alternative_name, :gender, :date_of_birth, :date_of_death, 
        :biography, :profession, :nationality, :religion, :source].each do |property|
        if old_person.send(property)
          new_person.send("#{property}=", old_person.send(property))
        end
      end
    end
    
    def add_new_content(person, json)
      person.place_of_birth = json['formatted_address']
      person.longitude = json['geometry']['location']['lng']
      person.latitude = json['geometry']['location']['lat']
      json['address_components'].each do |comp|
        if comp['types'].index('country') != nil
          person.country = comp['long_name']
          person.country_code = comp['short_name']
        end
      end
    end
    
    def add_place_of_death(old_person, new_person)
      if old_person.place_of_death != nil and old_person.place_of_death != ''
        response = lookup(old_person.place_of_death)
        if response != nil
          new_person.place_of_death = response['formatted_address']
        else
          new_person.place_of_death = old_person.place_of_death
        end
      end
    end

    def run
      runs = (Thief::Person.count(:place_of_birth.not => nil, :place_of_birth.not => '', :profession.not => nil, :profession.not => '', :date_of_birth.not => nil) / batch_size).ceil
      (0..runs).each do |run|
        Thief::Person.all(:offset => run * batch_size, :limit => batch_size, :place_of_birth.not => nil, :place_of_birth.not => '', :profession.not => nil, :profession.not => '', :date_of_birth.not => nil).each do |person|
          response = lookup(person.place_of_birth)
          if response != nil
            new_person = Thief::GeoPerson.new
            copy_old_content(person, new_person)
            add_new_content(new_person, response)
            add_place_of_death(person, new_person)
            new_person.save
          end
        end
      end
    end
    
    def batch_size
      10000
    end
  end
end