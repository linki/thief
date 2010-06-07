module Thief
  module Freebase
    class Integrator < Thief::Integrator
      map do |source, target|
        parts = source.name.split
        if parts.length > 1
          target.last_name = parts.last
          target.first_name = parts[0..parts.length - 2].join(' ')
        else
          target.first_name = source.name
        end
      end
    end
  end
end