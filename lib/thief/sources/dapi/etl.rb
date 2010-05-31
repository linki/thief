module Thief
  module DAPI
    class ETL < Thief::ETL
      def fetch
        Person.delete_all
      
        chunk_size   = 500
        start_at     = 0
        found_people = 0

        loop do
          fetch_url = "http://v1.d-api.de/parlament.bund.politiker?output_type=json&limit=#{start_at},#{chunk_size}"
          json_string = RestClient.get(fetch_url)
          parsed_json = Yajl::Parser.parse(json_string)

          parsed_json['data'].each do |person_data|
            person = Person.new
            person.external_id = person_data['id']
            [:bundestag_id, :vorname, :nachname, :zusatz, :ausgeschieden, :gestorben, :biografie,
             :partei, :wahlkreis, :wahlart, :url, :bundestag_image, :bundestag_image_source,
             :bundestag_bio_url, :jobs, :geboren_am, :geboren_ort, :familien_stand, :kinder,
             :religion, :wahlperiode, :wahl_de_id, :wahl_de_image, :wahl_de_image_source,
             :wahl_de_sociallinks].each do |attribute|
               person.send("#{attribute}=", person_data[attribute.to_s])
            end
            person.save!
          
            found_people += 1
          end

          parsed_json['data'].each do |person_data|
            Thief.logger.debug "#{person_data['vorname']} #{person_data['nachname']}"
          end
          
          break if parsed_json['data'].size < chunk_size
          
          start_at += chunk_size
        end
      
        Thief.logger.debug "Found #{found_people} people"
      end
    end
  end
end