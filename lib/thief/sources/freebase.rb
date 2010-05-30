['etl', 'integrator', 'person'].each do |lib|
  require File.expand_path("freebase/#{lib}", File.dirname(__FILE__))
end

module Thief
  module Sources
    class Freebase < Thief::Source
    end
  end
end