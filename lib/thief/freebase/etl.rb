require 'rubygems'
require 'open-uri'
require 'fileutils'

module Thief
  module Freebase
    NEWNAME = 'person.tsv'
    FILENAME = File.expand_path(File.join(File.dirname(__FILE__), NEWNAME))
    BASEURL = "http://toolserver.org/~sk/pd/output_pd_export.zip"
    EXTURL = ""
    
    class ETL < Thief::ETL
      
      def self.download_file!
       # get correct URL

        # download file
        puts 'downloading file'
        writeOut = open(FILENAME, 'wb')
        writeOut.write(open(URL).read)
        writeOut.close
      end
      
      def self.fetch(arguments)
        Person.all.destroy        
        if (!File.exist? FILENAME)
          download_file!
        end
        file = File.new(FILENAME, "r")
        counter = 1
        while (line = file.gets)
          c = 1
          person = Person.new
          # split every line and map to the person object
          for part in line.split(/\t/) do
            case c
              
            end 
            c += 1
          end
          person.save!
        
        end
        file.close
      end
    end
  end
end