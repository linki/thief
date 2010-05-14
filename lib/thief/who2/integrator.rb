module Thief
  module Who2
    class Integrator < Thief::Integrator
      def self.integrate
        Person.all.each do |person|
          #Thief::Person.create(
          #  :first_name => person.vorname,
          #  :last_name  => person.nachname
          #)
        end
      end
      
      def self.enabled?
        ETL.enabled?
      end
    end
  end
end