require 'spec_helper'

describe Metaphor do
  it "is version 0.2.1" do
    Metaphor::VERSION.should eql('0.2.1')
  end

  it "allows adding processors" do
    m = Metaphor.new
    lambda {
      m.processors << Class.new do; def call(*args); end; end
    }.should_not raise_error
  end

  describe "processing a message" do
    it "passes the message to each processor in turn" do
      m = Metaphor.new
      message = [ { 'message-id' => 'whatever' }, "message body" ]
      processing = sequence('processing')
      a = stub_everything('Processor A')
      a.expects(:call).once.with(*message).in_sequence(processing)
      b = stub_everything('Processor B')
      b.expects(:call).once.with(*message).in_sequence(processing)
      m.processors << a
      m.processors << b
      m.call(*message)
    end

    describe "if a processor returns a boolean false" do
      it "stops processing the message and discards it" do
        m = Metaphor.new
        processor_a = stub_everything('Halting Processor')
        processor_a.expects(:call).once.returns(false)
        processor_b = stub_everything('Unreachable Processor')
        processor_b.expects(:call).never
        m.processors << processor_a
        m.processors << processor_b
        m.call({}, "").should be_false
      end
    end

    describe "if a processor returns [new_headers, new_body]" do
      it "passes them to the next processor" do
        m = Metaphor.new
        new_message = [ [], "new body" ]
        processor_a = stub_everything('Mutating Processor')
        processor_a.expects(:call).once.returns(new_message)
        processor_b = stub_everything('Next Processor')
        processor_b.expects(:call).once.with(*new_message)
        m.processors << processor_a
        m.processors << processor_b
        m.call({}, "").should == new_message
      end
    end

    describe "if a processor returns any other value" do
      def generic_processor(return_value, message)
        @count ||= 0
        @count += 1
        processor = stub_everything("Generic Processor #{@count}")
        processor.expects(:call).once.with(*message).returns(return_value)
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
        m.call(*message).should == message
      end
    end
  end

  describe "reading messages from an input" do
    it "passes them to the processors until the input returns nil" do
      m = Metaphor.new
      m1 = [ { 'message-id' => 1 }, "message 1" ]
      m2 = [ { 'message-id' => 2 }, "message 2" ]
      processor = stub_everything('Processor')
      processor.expects(:call).once.with(*m1)
      processor.expects(:call).once.with(*m2)
      m.processors << processor
      input = stub_everything('Input')
      input.expects(:get).times(3).returns(m1, m2, nil)
      m.call(input)
    end
  end
end