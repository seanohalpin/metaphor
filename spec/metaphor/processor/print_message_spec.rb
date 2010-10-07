require 'spec_helper'
require 'metaphor/processor/print_message'

describe Metaphor::Processor::PrintMessage do
  it "should output the headers and body to STDOUT" do
    message = "example message body"

    stdout = stub_everything('STDOUT')
    stdout.expects(:puts).once.with(message)
    processor = Metaphor::Processor::PrintMessage.new(stdout)
    processor.call(message)
  end
end
