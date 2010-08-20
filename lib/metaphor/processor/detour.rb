class Metaphor
  module Processor
    class Detour
      def initialize(default, detour)
        @default = default
        @detour = Metaphor.new
        @detour.processors << detour
        @detour.processors << default
        @active = false
      end

      def activate
        @active = true
      end

      def deactivate
        @active = false
      end

      def active?
        @active
      end

      def call(headers, body)
        active_processor.call headers, body
      end

      private
      def active_processor
        (@active ? @detour : @default)
      end
    end
  end
end
