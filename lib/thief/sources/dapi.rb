require File.expand_path('../dapi/etl',        __FILE__)
require File.expand_path('../dapi/integrator', __FILE__)
require File.expand_path('../dapi/person',     __FILE__)

module Thief
  module Sources
    class DAPI < Thief::Source
    end
  end
end