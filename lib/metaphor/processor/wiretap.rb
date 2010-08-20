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

      def call(headers, body)
        @wiretap.call(headers, body) if active?
        @default.call(headers, body)
      end
    end
  end
end
