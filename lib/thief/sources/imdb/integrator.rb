module Thief
  module IMDb
    class Integrator < Thief::Integrator
      map :first_name => :first_name
      map :last_name  => :last_name
    end
  end
end