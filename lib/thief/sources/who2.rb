['etl', 'integrator', 'person'].each do |lib|
  require File.expand_path("who2/#{lib}", File.dirname(__FILE__))
end

module Thief
  module Sources
    class Who2 < Thief::Source
    end
  end
end