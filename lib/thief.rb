# require all *.rb files in support folder (/lib/thief/support/*.rb)
Dir[File.expand_path('thief/support/*.rb', File.dirname(__FILE__))].each {|f| require f}

Bundler.require(:default) if defined?(Bundler)

require 'thief/core_ext/dm-core/model'

require 'thief/source'

# require all *.rb files in cleaners folder (/lib/thief/cleaners/*.rb)
Dir[File.expand_path('thief/cleaners/*.rb', File.dirname(__FILE__))].each { |f| require f }

require 'thief/geo_coder'

require 'thief/etl'
require 'thief/integrator'
require 'thief/person'
require 'thief/geo_person'

require 'thief/tag'
require 'thief/tag_link'


# require all *.rb files in sources folder (/lib/thief/sources/*.rb)
Dir[File.expand_path('thief/sources/*.rb', File.dirname(__FILE__))].each { |f| require f }

module Thief
  def sources
    @sources ||= []
  end
  
  def fetch
    sources.each(&:fetch)
  end

  def integrate
    sources.each(&:integrate)
  end
  
  def cleanup
    cleaner.cleanup
  end
  
  def geocode
    geocoder.geocode
  end
  
  def cleaner
    @cleaner ||= Thief::Cleaners::Cleaner2.new
  end
  
  def compute_tags
    @professions, @profession_links = Hash.new(0), Hash.new(0)
    person_count = Thief::Person.count(:conditions => ['profession NOT NULL AND profession != ?', ''])
    runs = (person_count / 10000).ceil
    (0..runs).each do |run|
      Thief::Person.all(:conditions => ['profession NOT NULL AND profession != ?', ''], :offset => run * 10000, :limit => 10000).each do |person|
        professions = person.profession && person.profession.split(',')
        if professions
          professions.each do |profession|
            cleaned_profession = profession.gsub(/<\/?[^>]*>/, "").gsub("\n", "").strip
            @professions[cleaned_profession] += 1 unless cleaned_profession.empty?
          end
          if professions.size > 1
            for i in 0..(professions.size-2)
              cleaned_profession_1 = professions[i].gsub(/<\/?[^>]*>/, "").gsub("\n", "").strip
              for j in (i+1)..(professions.size-1)
                cleaned_profession_2 = professions[j].gsub(/<\/?[^>]*>/, "").gsub("\n", "").strip                
                @profession_links[[cleaned_profession_1, cleaned_profession_2].sort] += 1
              end
            end
          end
        end
      end
      Thief.logger.error "processed #{(run + 1) * 10000} of #{person_count} people."
    end
    
    Thief::Tag.delete_all
    @professions.each do |profession|
      tag = Thief::Tag.create!(:name => profession[0], :count => profession[1])
    end

    Thief::TagLink.delete_all
    @profession_links.each do |profession_link|
      Thief::TagLink.create!(:source_tag_name => profession_link[0][0], :target_tag_name => profession_link[0][1], :count => profession_link[1])
    end
  end
  
  def geocoder
    @geocoder ||= Thief::GeoCoder.new
  end
  
  def configure
    DataMapper::Logger.new(STDOUT, $DEBUG ? :debug : :error)
  end
  
  def database=(db_config)
    unless db_config =~ /:\/\//
      require 'yaml'
      db_config = YAML.load_file(db_config)[Thief.env][Thief.db_adapter]
    end
    raise Exception.new('environment or adapter not specified') unless db_config    
    Bundler.require(Thief.db_adapter) if defined?(Bundler)
    DataMapper.setup(:default, db_config)    
  end
  
  def setup(db_config = nil)
    configure
    self.database = db_config if db_config
    yield self if block_given?
  end
  
  def logger
    unless @logger
      require 'logger'    
      @logger = Logger.new(STDOUT)
      @logger.level = $DEBUG ? Logger::DEBUG : Logger::ERROR
      @logger.datetime_format = "%H:%M:%S"
    end
    @logger
  end
  
  def env
    ENV['RACK_ENV'] ||= ENV['THIEF_ENV'] ||= 'development'
  end

  def db_adapter
    ENV['THIEF_DB_ADAPTER'] ||= 'sqlite3'
  end
  
  def create_tables
    DataMapper.auto_migrate!
  end
  
  def tmp_dir
    File.expand_path('../tmp', File.dirname(__FILE__))
  end
  
  extend self
end

Bundler.require(ENV['THIEF_ENV']) if defined?(Bundler) && ENV['THIEF_ENV']