class Metaphor
  module Processor
    class StdoutProcessor
      def initialize(target = STDOUT)
        @target = target
      end

      def process(headers, body)
        @target.puts "HEADERS: #{headers.inspect}"
        @target.puts "BODY   : #{body.inspect}"
      end
    end
  end
end