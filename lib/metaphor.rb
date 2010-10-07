class Metaphor
  VERSION = '1.0.0'
  attr_accessor :processors

  def initialize
    self.processors = []
  end

  def call(input)
    if input.respond_to?(:gets)
      while message = input.gets
        process_message message
      end
    else
      process_message input
    end
  end

  private
  def process_message message
    processors.each do |processor|
      processor_output = processor.call(message)
      case
      when processor_output === false
        return false
      when processor_output != nil
        message = processor_output
      end
    end
    message
  end
end
