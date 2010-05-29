['etl', 'integrator', 'person'].each do |lib|
  require File.expand_path("imdb/#{lib}", File.dirname(__FILE__))
end

module Thief
  module Sources
    class IMDb < Thief::Source
    end
  end
end