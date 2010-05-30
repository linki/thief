require 'rubygems'
require 'open-uri'
require 'zip/zip'
require 'fileutils'

module Thief
  module Wikipedia
    NEWNAME = 'persondata.txt'
    FILENAME = File.expand_path(File.join(File.dirname(__FILE__), NEWNAME))
    TMPDIR = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', '..', 'tmp'))
    TMPZIP = File.join(TMPDIR, 'tmp.zip')
    
    class ETL < Thief::ETL
      
      def find_file(dir)
        file = nil
        for entry in Dir.new(File.expand_path(dir)) do
          if (entry.match(/.+\.txt/))
            file = File.join(dir, entry)
            break
          end
          next unless (File.directory?(File.join(dir, entry)) and entry != '.' and entry != '..')
          file = find_file(File.join(dir, entry))
          if (file != nil)
            break
          end
        end
        return file
      end
      
      def download_file!
        # check tmp dir and create
        puts 'checking directory'
        if (!File.exist? TMPDIR)
          FileUtils.makedirs(TMPDIR)
        end

        # download zip file
        puts 'downloading file'
        writeOut = open(TMPZIP, 'wb')
        writeOut.write(open("http://toolserver.org/~sk/pd/output_pd_export.zip").read)
        writeOut.close

        # unzip file
        puts 'unzipping file'
        Zip::ZipFile.open(TMPZIP) { |zip_file|
          zip_file.each { |f|
           next unless f.file?
           f_path = File.join(TMPDIR, f.name)
           FileUtils.makedirs(File.dirname(f_path))
           zip_file.extract(f, f_path) unless File.exist?(f_path)
          } 
        }

        # rename and move file
        puts 'renaming and moving file'
        datafile = find_file(TMPDIR)
        if (datafile != nil)
          File.rename(datafile, File.join(File.dirname(datafile), NEWNAME))
          FileUtils.mv(File.join(File.dirname(datafile), NEWNAME), File.expand_path(File.join(File.dirname(__FILE__), NEWNAME)))
        end

        #cleanup the mess
        puts 'removing tmp dir'
        FileUtils.rm_rf(TMPDIR)
      end
      
      def fetch
        repository.delete(Person.all)
        if (!File.exist? FILENAME)
          download_file!
        end
        file = File.new(FILENAME, "r")
        counter = 1
        while (line = file.gets)
          c = 1
          person = Person.new
          # split every line and extract the right parts
          for part in line.split(/\t/) do
            case c
              when 3 # name
                person.name = part
              when 4 # alternative names                  
                person.alternative_names = part
              when 5 # description
                person.short_description = part
              when 7 # date of birth                
                person.date_of_birth = part
              when 12 # place of birth
                person.place_of_birth = part
              when 14 # date of death
                person.date_of_death = part
              when 19 # place of death
                person.place_of_death = part
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