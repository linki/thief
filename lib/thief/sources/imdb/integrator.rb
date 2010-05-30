module Thief
  module IMDb
    class Integrator < Thief::Integrator
      map do |source, target|
        target.first_name = source.first_name
        target.last_name  = source.last_name
      end
    end
  end
end