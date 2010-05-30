['etl', 'integrator', 'person'].each do |lib|
  require File.expand_path("dapi/#{lib}", File.dirname(__FILE__))
end

module Thief
  module Sources
    class DAPI < Thief::Source
    end
  end
end