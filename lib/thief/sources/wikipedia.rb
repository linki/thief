['etl', 'integrator', 'person'].each do |lib|
  require File.expand_path("wikipedia/#{lib}", File.dirname(__FILE__))
end

module Thief
  module Sources
    class Wikipedia < Thief::Source
    end
  end
end