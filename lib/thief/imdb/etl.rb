require 'open-uri'
require 'fileutils'
require 'zlib'

module Thief
  module IMDB
    class ETL < Thief::ETL
      def self.fetch
        repository.delete(Person.all)
                
        sources = %w[actors.list actresses.list] # directors.list producers.list writers.list
        
        sources.each do |source|
          download_and_extract_file("http://ftp.sunet.se/pub/tv%2Bmovies/imdb/#{source}.gz", source) unless cached?(source)
        end
        
        overall_found_people = 0
        
        sources.each do |source|
          found_people = 0
          
          source_file = "#{Thief.cache_dir}/imbd/#{source}"
          puts "parsing #{source_file}..."
          
          File.open(source_file, 'rb').each do |line|
            if /^((.+), (.+))\s\t/ =~ line
              person_name = $1.split(', ').map(&:strip)
              
              person = Person.new
              person.first_name = person_name.last
              person.last_name  = person_name.first
              person.save!

              puts "#{person.first_name} #{person.last_name}"

              found_people += 1
            end
          end
          
          puts "Found #{found_people} people in #{source_file}"
          
          overall_found_people += found_people
        end
        
        puts "Found #{overall_found_people} people in all sources"
      end
      
      def self.download_and_extract_file(uri, target_name)
        FileUtils.mkdir_p "#{Thief.cache_dir}/imbd"

        puts "downloading #{uri}..."
        source = open(uri)

        destination = "#{Thief.cache_dir}/imbd/#{target_name}"
        
        puts "extracting #{uri} to #{destination}..."
        unzipped_source = Zlib::GzipReader.new(source)
        
        target_file = File.open(destination, 'wb')
        target_file.write(unzipped_source.read)
        target_file.close
        
        unzipped_source.close
      end
      
      def self.cached?(filename)
        File.exists?("#{Thief.cache_dir}/imbd/#{filename}")
      end
      
      def self.enabled?
        true
      end
    end
  end
end