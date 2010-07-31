require 'spec_helper'
require 'metaphor/processors/stdout_processor'

describe Metaphor::Processors::StdoutProcessor do
  it "should output the headers and body to STDOUT" do
    headers = { 'header-1' => 'value-1' }
    body = "example message body"

    stdout = stub_everything('STDOUT')
    processor = Metaphor::Processors::StdoutProcessor.new(stdout)
    stdout.expects(:puts).once.with("HEADERS: " + headers.inspect)
    stdout.expects(:puts).once.with("BODY   : " + body.inspect)
    processor.process(headers, body)
  end
end
