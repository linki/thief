
module Thief
  module Wikipedia
    class ETL < Thief::ETL
      def self.fetch(arguments)
        Person.all.destroy        
        
      end
    end
  end
end