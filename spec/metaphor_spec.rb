require 'spec_helper'
require 'helper/timestamp_processor'

describe Metaphor do
  it "is version 0.1.0" do
    Metaphor::VERSION.should eql('0.1.0')
  end

  it "allows adding processors" do
    m = Metaphor.new
    lambda {
      m.processors << Class.new do; def process(*args); end; end
    }.should_not raise_error
  end

  describe "processing a message" do
    it "passes the message to each processor in turn" do
      m = Metaphor.new
      processor_a = TimestampProcessor.new
      processor_b = TimestampProcessor.new
      m.processors << processor_a
      m.processors << processor_b
      m.process [], ""

      received_a = processor_a.received_message_at
      received_a.should_not be_nil
      received_b = processor_b.received_message_at
      received_b.should_not be_nil
      (received_a < received_b).should be_true
    end

    describe "if a processor returns a boolean false" do
      it "stops processing the message and discards it" do
        m = Metaphor.new
        processor_a = stub_everything('Halting Processor')
        processor_a.expects(:process).once.returns(false)
        processor_b = stub_everything('Unreachable Processor')
        processor_b.expects(:process).never
        m.processors << processor_a
        m.processors << processor_b
        m.process [], ""        
      end
    end
  end
end