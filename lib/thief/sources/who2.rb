require File.expand_path('../who2/etl',        __FILE__)
require File.expand_path('../who2/integrator', __FILE__)
require File.expand_path('../who2/person',     __FILE__)

module Thief
  module Sources
    class Who2 < Thief::Source
    end
  end
end