module Thief
  module DAPI
    class Person
      include DataMapper::Resource
    
      storage_names[:default] = 'dapi_people'

      property :id, Serial   # An auto-increment integer key
    
      property :external_id,            String    # 369
      property :bundestag_id,           String    # merkel_angela     
      property :vorname,                String    # Dr. Angela (title included)
      property :nachname,               String    # Merkel
      property :zusatz,                 String    #
      property :ausgeschieden,          String    # 0
      property :gestorben,              String    # 0
      property :biografie,              Text      # Geboren am 17. Juli 1954 in Hamburg....
      property :partei,                 String    # CDU/CSU
      property :wahlkreis,              String    # 015
      property :wahlart,                String    # Direkt
      property :url,                    String    # http://www.angela-merkel.de
      property :bundestag_image,        String    # http://www.bundestag.de/bundestag/abgeordnete17/mdbjpg/m/merkel_angela.jpg
      property :bundestag_image_source, String    # Presse- und Informationsamt der Bundesregierung/Laurence Chaperon
      property :bundestag_bio_url,      String    # http://www.bundestag.de/bundestag/abgeordnete17/biografien/M/merkel_angela.html
      property :jobs,                   String    # Diplomphysikerin,Bundeskanzlerin
      property :geboren_am,             String    # 1954-07-17
      property :geboren_ort,            String    # empty (Hamburg)
      property :familien_stand,         String    # empty (verheiratet)
      property :kinder,                 Integer   # 0
      property :religion,               String    #
      property :wahlperiode,            Integer   # 17
      property :wahl_de_id,             Integer   # 11
      property :wahl_de_image,          String    # http://static.wahl.compuccinocloud.com/imagecache/politiker_mittel/kdn_86192.jpg
      property :wahl_de_image_source,   String    # www.wahl.de
      property :wahl_de_sociallinks,    String    # [{"url"=>"http://www.meinvz.net/Profile/94f3c589f34e637e", "service"=>"meinvz", "fake"=>"0"}, {"url"=>"http...
    end
  end
end
