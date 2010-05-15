module Thief
  module IMDb
    class Integrator < Thief::Integrator
      def self.integrate
        Person.all.each do |person|
          Thief::Person.create(
            :first_name => person.first_name,
            :last_name  => person.last_name
          )
        end
      end
      
      def self.enabled?
        ETL.enabled?
      end      
    end
  end
end