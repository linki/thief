require File.expand_path('../wikipedia/etl',        __FILE__)
require File.expand_path('../wikipedia/integrator', __FILE__)
require File.expand_path('../wikipedia/person',     __FILE__)

module Thief
  module Sources
    class Wikipedia < Thief::Source
    end
  end
end