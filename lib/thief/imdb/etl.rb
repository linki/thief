require 'open-uri'
require 'fileutils'
require 'zlib'

module Thief
  module IMDb
    class ETL < Thief::ETL
      class << self
        def fetch
          repository.delete(Person.all)
                
          sources = %w[actors.list actresses.list] # directors.list producers.list writers.list
        
          sources.each do |source|
            download_and_extract_file("http://ftp.sunet.se/pub/tv%2Bmovies/imdb/#{source}.gz", source)
          end
        
          overall_found_people = 0
        
          sources.each do |source|
            found_people = 0
          
            source_file = cached?(source) ? "#{Thief.tmp_dir}/imdb/cache/#{source}" : "#{Thief.tmp_dir}/imdb/#{source}"
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

          sources.each do |source|
            FileUtils.rm("#{Thief.tmp_dir}/imdb/#{source}") if File.exists?("#{Thief.tmp_dir}/imdb/#{source}")
          end
        
          puts "Found #{overall_found_people} people in all sources"
        end
      
        def download_file(uri, target_name)
          begin
            FileUtils.mkdir_p "#{Thief.tmp_dir}/imdb/cache"

            puts "downloading #{uri}..."
            source_file = open(uri)

            destination = "#{Thief.tmp_dir}/imdb/cache/#{target_name}"

            target_file = File.open(destination, 'wb')
            target_file.write(source_file.read)
            target_file.close
          rescue
            target_file && FileUtils.rm(target_file)
          end        
        end

        def extract_file(source_name, target_name)
          begin
            source_path = "#{Thief.tmp_dir}/imdb/cache/#{source_name}"
            destination = "#{Thief.tmp_dir}/imdb/#{target_name}"

            puts "extracting #{source_path} to #{destination}..."

            source_file = File.open(source_path, 'rb')
            unzipped_source = Zlib::GzipReader.new(source_file)

            target_file = File.open(destination, 'wb')
            target_file.write(unzipped_source.read)
            target_file.close
            
            source_file.close
          rescue
            target_file && FileUtils.rm(target_file)
          end
        end

        def download_and_extract_file(uri, target_name)
          unless cached?(target_name)
            filename = uri.split('/').last
            download_file(uri, filename) unless cached?(filename)
            extract_file(filename, target_name)
          end
        end

        def cached?(filename)
          File.exists?("#{Thief.tmp_dir}/imdb/cache/#{filename}")
        end
      
        def enabled?
          true
        end
      end
    end
  end
end