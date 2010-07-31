# Run me like this:
# ruby -I lib/ -rubygems examples/reverse_body.rb

require 'bundler'
Bundler.setup
require 'metaphor'
require 'metaphor/input/stdin_input'
require 'metaphor/processor/stdout_processor'

class Reverse
  def process(headers, body)
    [ headers, body.reverse ]
  end
end

m = Metaphor.new
m.processors << Reverse.new
m.processors << Metaphor::Processor::StdoutProcessor.new
m.process Metaphor::Input::StdinInput.new