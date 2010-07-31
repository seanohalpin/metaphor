class Metaphor
  module Processor
    class StdoutProcessor
      def initialize(target = STDOUT)
        @target = target
      end

      def process(headers, body)
        headers.each_pair do |header, value|
          @target.puts "#{header}:#{value}"
        end
        @target.puts
        @target.puts body
        @target.puts
      end
    end
  end
end