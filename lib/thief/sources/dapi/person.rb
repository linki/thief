module Thief
  module DAPI
    class Person
      include DataMapper::Resource
  
      storage_names[:default] = 'dapi_people'

      property :id, Serial   # An auto-increment integer key
  
      property :external_id,            String, :length => 255    # 369
      property :bundestag_id,           String, :length => 255    # merkel_angela     
      property :vorname,                String, :length => 255    # Dr. Angela (title included)
      property :nachname,               String, :length => 255    # Merkel
      property :zusatz,                 String, :length => 255   #
      property :ausgeschieden,          String, :length => 255   # 0
      property :gestorben,              String, :length => 255    # 0
      property :biografie,              Text      # Geboren am 17. Juli 1954 in Hamburg....
      property :partei,                 String, :length => 255    # CDU/CSU
      property :wahlkreis,              String, :length => 255    # 015
      property :wahlart,                String, :length => 255    # Direkt
      property :url,                    String, :length => 255    # http://www.angela-merkel.de
      property :bundestag_image,        String, :length => 255    # http://www.bundestag.de/bundestag/abgeordnete17/mdbjpg/m/merkel_angela.jpg
      property :bundestag_image_source, String, :length => 255    # Presse- und Informationsamt der Bundesregierung/Laurence Chaperon
      property :bundestag_bio_url,      String, :length => 255    # http://www.bundestag.de/bundestag/abgeordnete17/biografien/M/merkel_angela.html
      property :jobs,                   String, :length => 255    # Diplomphysikerin,Bundeskanzlerin
      property :geboren_am,             String, :length => 255    # 1954-07-17
      property :geboren_ort,            String, :length => 255    # empty (Hamburg)
      property :familien_stand,         String, :length => 255    # empty (verheiratet)
      property :kinder,                 String, :length => 255    # 0
      property :religion,               String, :length => 255    #
      property :wahlperiode,            Integer   # 17
      property :wahl_de_id,             Integer   # 11
      property :wahl_de_image,          String, :length => 255    # http://static.wahl.compuccinocloud.com/imagecache/politiker_mittel/kdn_86192.jpg
      property :wahl_de_image_source,   String, :length => 255    # www.wahl.de
      property :wahl_de_sociallinks,    Text      # [{"url"=>"http://www.meinvz.net/Profile/94f3c589f34e637e", "service"=>"meinvz", "fake"=>"0"}, {"url"=>"http...
    end
  end
end
