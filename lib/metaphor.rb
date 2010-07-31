class Metaphor
  VERSION = '0.1.0'
  attr_accessor :processors

  def initialize
    self.processors = []
  end

  def process(headers, message)
    processors.each do |processor|
      processor.process headers, message
    end
  end
end