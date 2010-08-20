class Metaphor
  module Processor
    class PrintMessage
      def initialize(target = STDOUT)
        @target = target
      end

      def call(headers, body)
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