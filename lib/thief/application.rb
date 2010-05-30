Bundler.require(:application) if defined?(Bundler)

require 'erb'

module Thief
  class Application < Sinatra::Base
    before do
      content_type :html, 'charset' => 'utf-8'
    end

    get '/' do
      @people = Thief::Person.all(:order => [:first_name, :last_name])
      erb :index
    end
    
    set :views, File.expand_path('application/views', File.dirname(__FILE__))
  
    # get '/people/page/:page' do
    #   @people = Thief::Person.all(:offset => 100 * params[:page].to_i, :limit => 100)
    #   erb :index
    # end    
  end
end