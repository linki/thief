require 'rubygems'
require 'open-uri'

require 'net/http'

# Lengthen timeout in Net::HTTP
module Net
    class HTTP
        alias old_initialize initialize

        def initialize(*args)
            old_initialize(*args)
            @read_timeout = 2*60     # 3 minutes
        end
    end
end

module Thief
  module Who2
    BASEURL = 'http://www.who2.com/'
    
    class ETL < Thief::ETL
      
      def self.get_links
        document = open(BASEURL).read
        match = document.match(/<div id=\"alpha_nav\">(.*?)<\/div>/m)
        document = ''
        if (match.captures.size == 1)
          document = match.captures[0]
        end
        exts = []
        document.scan(/href=\"(.+?)\"/) { |link| exts << link[0] }
        
        sites = [] 
        exts.each do |link|
          doc = open(BASEURL + link).read
          m = doc.match(/<div id=\"content\">.*?<ul>(.*?)<\/ul>.*?<\/div>/m)
          if (m.captures.size == 1)
            m.captures[0].scan(/href=\"(.+?)\"/) { |l| sites << l[0] }
          end
        end
        puts "Found #{sites.size} biographies"
        return sites
      end
      
      def self.fetch
        repository.delete(Person.all)
        
        # get all links
        links = get_links
        puts "Start crawling"
        
        # open every link and parse content
        links.each do |link|
          doc = open(BASEURL + link).read
          person = Person.new
          # external id
          person.external_id = link
          # name
          mname = doc.match(/<div id=\"content\">.*?<h1>(.+?) Biography<\/h1>.*?<\/div>/m)
          if (mname != nil and mname.captures.size == 1)
            person.name = mname.captures[0]
          end
          # profession
          mprofs = doc.match(/<h2 id=\"subtitle\">(.+?)<\/h2>/m)
          if (mprofs != nil and mprofs.captures.size == 1)
            mprofs.captures[0].scan(/<a.*?>(.+?)<\/a>/) do |p| 
              if (person.profession == nil)
                person.profession = p[0]
              else
                person.profession += " / #{p[0]}"
              end
            end
          end
          # biography
          mbio = doc.match(/<h2 id=\"subtitle\">.+?<\/h2>.*?(<p>.+?)<p>.*?<b>Extra credit<\/b>/m)
          if (mbio != nil and mbio.captures.size == 1)
            person.biography = mbio.captures[0].gsub(/(<p>|<\/p>)/, '')
          end
          # extra credit
          mextra = doc.match(/<b>Extra credit<\/b>\": (.+?)<\/p>/m)
          if (mextra != nil and mextra.captures.size == 1)
            person.extra_credit = mextra.captures[0]
          end
          # date of birth
          mbirth = doc.match(/<h3>Birth<\/h3>\s*?<p>(.+?)<\/p>/m)
          if (mbirth != nil and mbirth.captures.size == 1)
            person.date_of_birth = mbirth.captures[0].gsub(/(<a.*?>|<\/a>)/, '').gsub(/\s/, ' ')
          end
          # place of birth
          mplace = doc.match(/<h3>Birthplace<\/h3>\s*?<p>(.+?)<\/p>/m)
          if (mplace != nil and mplace.captures.size == 1)
            person.place_of_birth = mplace.captures[0].gsub(/(<a.*?>|<\/a>)/, '').gsub(/\s/, ' ')
          end
          # death
          mdeath = doc.match(/<h3>Death<\/h3>\s*?<p>(.+?)<\/p>/m)
          if (mdeath != nil and mdeath.captures.size == 1)
            person.death = mdeath.captures[0].gsub(/(<a.*?>|<\/a>)/, '').gsub(/\s/, ' ')
          end
          # best known as
          mknown = doc.match(/<h3>Best Known As<\/h3>\s*?<p>(.+?)<\/p>/m)
          if (mknown != nil and mknown.captures.size == 1)
            person.best_known_as = mknown.captures[0].gsub(/(<a.*?>|<\/a>)/, '').gsub(/\s/, ' ')
          end
          person.save!
        end
        
      end
      
      def self.enabled?
        true
      end
    end
  end
end