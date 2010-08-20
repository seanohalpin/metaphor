# Run me like this:
# ruby -I lib/ -rubygems examples/reverse_body.rb

require 'bundler'
Bundler.setup
require 'metaphor'
require 'metaphor/input/stdin_input'
require 'metaphor/processor/print_message'

class Reverse
  def process(headers, body)
    [ headers, body.reverse ]
  end
end

m = Metaphor.new
m.processors << Reverse.new
m.processors << Metaphor::Processor::PrintMessage.new
m.process Metaphor::Input::StdinInput.new