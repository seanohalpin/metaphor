class Metaphor
  VERSION = '0.2.1'
  attr_accessor :processors

  def initialize
    self.processors = []
  end

  def call(*args)
    case args.size
    when 1
      while message = args.first.get
        process_message(*message)
      end
    when 2
      process_message(*args)
    end
  end

  private
  def process_message(headers, body)
    processors.each do |processor|
      processor_output = processor.call(headers, body)
      case
      when processor_output === false
        return false
      when processor_output.respond_to?(:size) && processor_output.size == 2
        headers, body = processor_output
      end
    end
    [ headers, body ]
  end
end