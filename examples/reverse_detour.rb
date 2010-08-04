# The Metaphor set up here looks something like:
#
# [ StdinInput ] -> [ Detour ] -> [ StdoutProcessor ]
#                        \                  /
#                         \-> [ Reverse ] -/
#
# Run me like this:
#   ruby -I lib/ -rubygems examples/reverse_detour.rb
# then I won't route messages through the detour.
#
# Send me an USR1 signal to cause the messages to be sent through the
# detour.

puts "You can send me an USR1 signal by running this:"
puts "  kill -USR1 #{Process.pid}"
puts

require 'bundler'
Bundler.setup
require 'metaphor'
require 'metaphor/input/stdin_input'
require 'metaphor/processor/stdout_processor'
require 'metaphor/processor/detour'

include Metaphor::Processor

class Reverse
  def process(headers, body)
    [ headers, body.reverse ]
  end
end

stdout = StdoutProcessor.new
reverse = Reverse.new
detour = Detour.new stdout, reverse

trap("USR1") do
  detour.active? ? detour.deactivate : detour.activate
end

m = Metaphor.new
m.processors << detour
m.process Metaphor::Input::StdinInput.new