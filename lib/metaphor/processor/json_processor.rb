class Metaphor
  module Processor
    class JsonProcessor
      def initialize
        require 'json'
      end

      def process(headers, body)
        [ headers, JSON[body] ]
      end
    end
  end
end