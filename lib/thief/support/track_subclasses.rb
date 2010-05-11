module Thief
  module Support
    module TrackSubclasses
      def inherited(child)
        @children ||= [] 
        @children << child
      end 

      def children
        @children || []
      end
    end
  end
end