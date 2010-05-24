require File.expand_path('../imdb/etl',        __FILE__)
require File.expand_path('../imdb/integrator', __FILE__)
require File.expand_path('../imdb/person',     __FILE__)

module Thief
  module Sources
    class IMDb < Thief::Source
    end
  end
end