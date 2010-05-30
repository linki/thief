require 'open-uri'
require 'fileutils'
require 'zlib'

module Thief
  module IMDb
    class ETL < Thief::ETL
      def fetch
        Person.delete_all
              
        sources = %w[actors.list actresses.list] # %w[alternate-versions.list] # directors.list producers.list writers.list
      
        sources.each do |source|
          download_and_extract_file("http://ftp.sunet.se/pub/tv%2Bmovies/imdb/#{source}.gz", source)
        end
      
        overall_found_people = 0
      
        sources.each do |source|
          found_people = 0
        
          source_file  = "#{Thief.tmp_dir}/imdb/"
          source_file += "cache/" if cached?(source)
          source_file += source
          
          puts "parsing #{source_file}..."
        
          File.open(source_file, 'rb').each do |line|
            if /^((.+), (.+))\s\t/ =~ line
              person_name = $1.split(', ').map(&:strip)
                            
              person = Person.new
              person.first_name = person_name.last
              person.last_name  = person_name.first
              person.save!
              
              puts "#{person.first_name} #{person.last_name}" if $DEBUG

              found_people += 1
            end
          end
        
          puts "Found #{found_people} people in #{source_file}" if $DEBUG
        
          overall_found_people += found_people
        end

        sources.each do |source|
          FileUtils.rm("#{Thief.tmp_dir}/imdb/#{source}") if File.exists?("#{Thief.tmp_dir}/imdb/#{source}")
        end
      
        puts "Found #{overall_found_people} people in all sources" if $DEBUG
      end
    end
  end
end