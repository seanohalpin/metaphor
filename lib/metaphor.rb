class Metaphor
  VERSION = '0.1.0'
  attr_accessor :processors

  def initialize
    self.processors = []
  end

  def process(headers, body)
    processors.each do |processor|
      processor_output = processor.process(headers, body)
      case processor_output
      when FalseClass
        return
      end
    end
  end
end