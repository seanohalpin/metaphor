class Metaphor
  module Processor
    class PrintMessage
      def initialize(target = STDOUT)
        @target = target
      end

      def call message
        @target.puts message
      end
    end
  end
end
