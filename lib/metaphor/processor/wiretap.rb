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

      def call message
        @wiretap.call(message) if active?
        @default.call(message)
      end
    end
  end
end
