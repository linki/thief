module Thief
  module Support
    module TrackSubclasses
      def children
        @children ||= []
      end

      def inherited(child)
        children << child
      end 
    end
  end
end