class Metaphor
  module Processor
    class Wiretap
      def initialize(default, wiretap)
        @default = default
        @wiretap = wiretap
        @active = false
      end

      def active?
        @active
      end

      def activate
        @active = true
      end

      def deactivate
        @active = false
      end

      def process(headers, body)
        @wiretap.process(headers, body) if active?
        @default.process(headers, body)
      end
    end
  end
end
