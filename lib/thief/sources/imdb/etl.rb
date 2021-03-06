require 'open-uri'
require 'fileutils'
require 'zlib'

module Thief
  module IMDb
    class ETL < Thief::ETL
      def fetch
        Person.delete_all
              
        sources = %w[actors.list actresses.list] # %w[alternate-versions.list] # directors.list producers.list writers.list
        
        gender = {'actors.list' => 'Male', 'actresses.list' => 'Female'}
      
        sources.each do |source|
          download_and_extract_file("http://ftp.sunet.se/pub/tv%2Bmovies/imdb/#{source}.gz", source)
        end
      
        overall_found_people = 0
      
        sources.each do |source|
          found_people = 0
        
          source_file  = "#{Thief.tmp_dir}/IMDb/"
          source_file += "cache/" if cached?(source)
          source_file += source
          
          puts "parsing #{source_file}..."
        
          File.open(source_file, 'rb').each do |line|
            if /^((.+), (.+))\s\t/ =~ line
              person_name = $1.split(', ').map(&:strip)
                            
              person = Person.new
              person.first_name = person_name.last[0..254]
              person.last_name  = person_name.first[0..254]
              person.gender     = gender[source]
              person.save!
              
              Thief.logger.debug "#{person.first_name} #{person.last_name}"

              found_people += 1
            end
          end
        
          Thief.logger.debug "Found #{found_people} people in #{source_file}"
        
          overall_found_people += found_people
        end

        sources.each do |source|
          FileUtils.rm("#{Thief.tmp_dir}/IMDb/#{source}") if File.exists?("#{Thief.tmp_dir}/IMDb/#{source}")
        end
      
        Thief.logger.debug "Found #{overall_found_people} people in all sources"
      end
    end
  end
end