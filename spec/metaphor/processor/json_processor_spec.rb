require 'spec_helper'
require 'metaphor/processor/json_processor'

describe Metaphor::Processor::JsonProcessor do
  describe "processing a Ruby Hash" do
    it "converts it to the equivalent JSON hash" do
      m = Metaphor::Processor::JsonProcessor.new
      hash = { 'a' => 1, 'b' => 2, 'c' => 3 }
      headers, json = m.process({}, hash)
      json.should == '{"a":1,"b":2,"c":3}'
      headers['content-type'].should == 'application/json'
    end
  end

  describe "processing a JSON Hash" do
    m = Metaphor::Processor::JsonProcessor.new
    json = '{"a":1,"b":2,"c":3}'
    headers, json = m.process({}, json)
    json.should == { 'a' => 1, 'b' => 2, 'c' => 3 }
    headers['content-type'].should == 'application/x-ruby'
  end
end
