Bundler.require(:application) if defined?(Bundler)

require 'erb'

module Thief
  class Application < Sinatra::Base
    before do
      content_type :html, 'charset' => 'utf-8'
    end

    get '/' do
      @people_count = Thief::Person.count(:conditions => ['first_name LIKE ? OR last_name LIKE ? OR profession LIKE ?', "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%"])
      @people = Thief::Person.all(:conditions => ['first_name LIKE ? OR last_name LIKE ? OR profession LIKE ?', "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%"],
                                  :offset => (params[:page] || 0).to_i * 100, :limit => 100,
                                  :order => [:first_name, :last_name])
      erb :index
    end

    get '/people/:id' do
      @person = Thief::Person.get(params[:id])
      erb :show
    end

    get '/cloud' do
      if params[:filter] && !params[:filter].empty?
        max = Thief::TagLink.count(:conditions => ['source_tag_name = ? OR target_tag_name = ?', params[:filter], params[:filter]])
        @cloud = Hash.new
        Thief::TagLink.all(:conditions => ['source_tag_name = ?', params[:filter]]).each do |tag_link|
          weight = 20 * tag_link.count / max
          @cloud[tag_link.target_tag_name] = weight if weight > 0
        end
        Thief::TagLink.all(:conditions => ['target_tag_name = ?', params[:filter]]).each do |tag_link|
          weight = 20 * tag_link.count / max
          @cloud[tag_link.source_tag_name] = weight if weight > 0
        end
        @map_data = repository(:default).adapter.select("select country, country_code, count(*) as count from geo_people where profession like ? group by country;", params[:filter])
      else
        max = Thief::Tag.max(:count)
        @cloud = Hash.new
        Thief::Tag.all.each do |tag|
          weight = 20 * tag.count / max
          @cloud[tag.name] = weight if weight > 0
        end
        @map_data = []
      end
      
      erb :cloud
    end

    get '/pairs' do
      max = Thief::TagLink.max(:count)
      @cloud = Hash.new
      Thief::TagLink.all.each do |tag_link|
        weight = 20 * tag_link.count / max
        @cloud[tag_link.name] = weight if weight > 0
      end
      erb :cloud
    end

    get '/professions' do
      if params[:search].include?('/')
        conditions = {:conditions => ['profession LIKE ? AND profession LIKE ?', "%#{params[:search].split('/')[0]}%", "%#{params[:search].split('/')[1]}%"]}
      else
        conditions = {:conditions => ['profession LIKE ?', "%#{params[:search]}%"]}
      end
      @people_count = Thief::Person.count(conditions)
      
      conditions.merge! :offset => (params[:page] || 0).to_i * 100, :limit => 100,
                        :order => [:first_name, :last_name]
      
      @people = Thief::Person.all(conditions)
      erb :professions
    end
        
    set :views, File.expand_path('application/views', File.dirname(__FILE__))
    set :public, File.expand_path('application/static', File.dirname(__FILE__))
    
    get '/maps' do
      erb :maps
    end
  end
end