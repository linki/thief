module Thief
  class ETL
    def self.inherited(child)
      @children ||= [] 
      @children << child
    end 

    def self.children
      @children
    end
  end
end