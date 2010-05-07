require 'uri'
require 'yajl/gzip'
require 'yajl/deflate'
require 'yajl/http_stream'
 
module Thief
  module DAPI
    class ETL < Thief::ETL
      def self.fetch(arguments)
        Person.all.destroy        
        
        first_name = arguments[:first_name]
        last_name  = arguments[:last_name]
        
        url = URI.parse("http://v1.d-api.de/parlament.bund.politiker/get?vorname=#{first_name}&nachname=#{last_name}&limit=10&output_type=json")
        Yajl::HttpStream.get(url) do |response_hash|
          # response_hash['data'].first.each do |key, val|
          #   puts "#{key} - #{val}"
          # end
          response_hash['data'].each do |person_data|
            person = Person.new
            person.external_id = person_data['id']
            [:bundestag_id, :vorname, :nachname, :zusatz, :ausgeschieden, :gestorben, :biografie, :partei, :wahlkreis, :wahlart, :url, :bundestag_image, :bundestag_image_source,
             :bundestag_bio_url, :jobs, :geboren_am, :geboren_ort, :familien_stand, :kinder, :religion, :wahlperiode,
             :wahl_de_id, :wahl_de_image, :wahl_de_image_source, :wahl_de_sociallinks].each do |attribute|
               person.send("#{attribute}=", person_data[attribute.to_s])
            end
            person.save!
          end
        end
      end
    end
  end
end