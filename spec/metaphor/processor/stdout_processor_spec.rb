require 'spec_helper'
require 'metaphor/processor/stdout_processor'

describe Metaphor::Processor::StdoutProcessor do
  it "should output the headers and body to STDOUT" do
    headers = {
      'header-1' => 'value-1',
      'header-2' => 'value-2',
      'header-3' => 'value-3'
    }
    body = "example message body"

    stdout = stub_everything('STDOUT')
    processor = Metaphor::Processor::StdoutProcessor.new(stdout)
    o = sequence('output')
    h = sequence('headers')
    b = sequence('body')
    stdout.expects(:puts).once.with("header-1:value-1").in_sequence(h).in_sequence(o)
    stdout.expects(:puts).once.with("header-2:value-2").in_sequence(h).in_sequence(o)
    stdout.expects(:puts).once.with("header-3:value-3").in_sequence(h).in_sequence(o)
    stdout.expects(:puts).once.with().in_sequence(h).in_sequence(o)
    stdout.expects(:puts).once.with(body).in_sequence(b).in_sequence(o)
    stdout.expects(:puts).once.with().in_sequence(b).in_sequence(o)
    processor.process(headers, body)
  end
end
