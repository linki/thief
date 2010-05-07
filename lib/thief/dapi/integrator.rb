module Thief
  module DAPI
    class Integrator < Thief::Integrator
      def self.integrate!
        Person.all.each do |person|
          Thief::Person.create(
            :first_name => person.vorname,
            :last_name  => person.nachname
          )
        end
      end
    end
  end
end