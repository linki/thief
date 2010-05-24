require File.expand_path('../freebase/etl',        __FILE__)
require File.expand_path('../freebase/integrator', __FILE__)
require File.expand_path('../freebase/person',     __FILE__)

module Thief
  module Sources
    class Freebase < Thief::Source
    end
  end
end