class Metaphor
  module Processor
    class JsonProcessor
      def initialize
        require 'json'
      end

      def call(headers, body)
        result = JSON[body]
        headers['content-type'] = case result
        when Hash:   'application/x-ruby'
        when String: 'application/json'
        end
        [ headers, result ]
      end
    end
  end
end