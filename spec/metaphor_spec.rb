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
      m.process({}, "")

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
        m.process({}, "")
      end
    end

    describe "if a processor returns [new_headers, new_body]" do
      it "passes them to the next processor" do
        m = Metaphor.new
        new_message = [ [], "new body" ]
        processor_a = stub_everything('Mutating Processor')
        processor_a.expects(:process).once.returns(new_message)
        processor_b = stub_everything('Next Processor')
        processor_b.expects(:process).once.with(*new_message)
        m.processors << processor_a
        m.processors << processor_b
        m.process({}, "")
      end
    end

    describe "if a processor returns any other value" do
      def generic_processor(return_value, message)
        @count ||= 0
        @count += 1
        processor = stub_everything("Generic Processor #{@count}")
        processor.expects(:process).once.with(*message).returns(return_value)
        processor
      end

      it "passes them to the next processor" do
        m = Metaphor.new
        message = [ [], "body" ]
        m.processors << generic_processor(nil, message)
        m.processors << generic_processor(true, message)
        m.processors << generic_processor("maybe", message)
        m.processors << generic_processor(12345, message)
        m.processors << generic_processor(Object.new, message)
        m.process *message
      end
    end
  end

  describe "reading messages from an input" do
    it "passes them to the processors until the input returns nil" do
      m = Metaphor.new
      m1 = [ { 'message-id' => 1 }, "message 1" ]
      m2 = [ { 'message-id' => 2 }, "message 2" ]
      processor = stub_everything('Processor')
      processor.expects(:process).once.with(*m1)
      processor.expects(:process).once.with(*m2)
      m.processors << processor
      input = stub_everything('Input')
      input.expects(:get).times(3).returns(m1, m2, nil)
      m.process(input)
    end
  end
end