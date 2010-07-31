require 'spec_helper'
require 'metaphor/input/stdin_input'

class Responder
  def initialize
    @lines = []
  end

  def <<(line)
    @lines << line
  end

  def readline
    @lines.shift.to_s
  end
end

describe Metaphor::Input::StdinInput do
  it "prompts for headers and body on STDOUT and returns them" do
    responses = Responder.new
    responses << "HEADER1:VALUE1\n"
    responses << "HEADER2:VALUE2\n"
    responses << "HEADER3:VALUE3\n"
    responses << "\n"
    responses << "message body\n"
    responses << "\n"

    output = sequence('output')
    stdout = stub_everything('STDOUT')
    input = Metaphor::Input::StdinInput.new(responses, stdout)

    prompts = %Q(Enter headers in the format header:value.
    Each header:value pair should be followed by a newline.
    When you're done enter a blank line.
    Enter the message body.
    When you're done enter a blank line.).split(/\n/).map{|l|l.strip}
    prompts.each do |prompt|
      stdout.expects(:puts).with(prompt).in_sequence(output)
    end

    headers, body = input.get
    headers.should eql(
      "HEADER1" => "VALUE1",
      "HEADER2" => "VALUE2",
      "HEADER3" => "VALUE3"
    )
    body.should eql("message body")
  end
end
