require 'rubygems'
require 'open-uri'
require 'fileutils'

module Thief
  module Freebase
    NEWNAME = 'person.tsv'
    FILENAME = File.expand_path(File.join(File.dirname(__FILE__), NEWNAME))
    BASEURL = "http://download.freebase.com/datadumps/"
    EXTURL = "/browse/people/#{NEWNAME}"

    class ETL < Thief::ETL
      
      def download_file!
        # TODO: catch all errors!
        
        # get correct URL
        puts 'searching for correct URL'
        document = open(BASEURL).read
        m = document.match(/.*href=\"\/datadumps\/(.*?)\/browse\".*/m)
        if (m.captures.size != 1) 
          return false
        end
        # download file
        puts 'downloading file'
        writeOut = open(FILENAME, 'wb')
        writeOut.write(open(BASEURL + m.captures[0] + EXTURL).read)
        writeOut.close
        return true
      end
      
      def fetch
        Person.delete_all
        if (!File.exist? FILENAME)
          download_file!
        end
        file = File.new(FILENAME, "r")
        counter = 1
        first = true
        attrs = [:name, :external_id, :date_of_birth, :place_of_birth, :nationality,
          :religion, :gender, :meta_web_user_s, :parents, :children, :eployment_history, 
          :signature, :spouse_s, :sibling_s, :weight_kg, :height_meters, :education, 
          :profession, :quotations, :places_lived, :ethnicity, :quotationsbook_id, 
          :age, :tvrage_id]
        while (line = file.gets)
          if (first)
            first = false
            next
          end
          c = 0 # was 1
          person = Person.new
          # split every line and map to the person object
          for part in line.split(/\t/) do
            if (c == 24)
              break
            end
            person.send("#{attrs[c]}=", part)
            c += 1
          end
          person.save!
        
        end
        file.close
      end
    end
  end
end