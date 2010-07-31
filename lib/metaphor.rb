class Metaphor
  VERSION = '0.1.0'
  attr_accessor :processors

  def initialize
    self.processors = []
  end

  def process(headers, body)
    processors.each do |processor|
      processor_output = processor.process(headers, body)
      case
      when processor_output === false
        return
      when processor_output.respond_to?(:size) && processor_output.size == 2
        headers, body = processor_output
      end
    end
  end
end