require 'spec_helper'

describe Metaphor do
  it "is version 1.0.0" do
    Metaphor::VERSION.should eql('1.0.0')
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
      message = "Foo bar baz quux"
      processing = sequence('processing')
      a = stub_everything('Processor A')
      a.expects(:call).once.with(message).in_sequence(processing)
      b = stub_everything('Processor B')
      b.expects(:call).once.with(message).in_sequence(processing)
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
        m.call("").should be_false
      end
    end

    describe "if a processor returns something that's not nil or false" do
      it "passes that value to the next processor" do
        m = Metaphor.new
        new_message = [ [], "new body" ]
        processor_a = stub_everything('Mutating Processor')
        processor_a.expects(:call).once.returns(new_message)
        processor_b = stub_everything('Next Processor')
        processor_b.expects(:call).once.with(new_message)
        m.processors << processor_a
        m.processors << processor_b
        m.call("Initial Message").should == new_message
      end
    end

    describe "if a processor returns nil" do
      def generic_processor(expected_message)
        @count ||= 0
        @count += 1
        processor = stub_everything("Generic Processor #{@count}")
        processor.expects(:call).once.with(expected_message).returns(nil)
        processor
      end

      it "passes it to the next processor" do
        m = Metaphor.new
        message = "Lorum Ipsum Dolor..."
        processor_a = stub_everything('Return Nil Processor')
        processor_a.expects(:call).once.returns(nil)
        processor_b = stub_everything('Next Processor')
        processor_b.expects(:call).once.with(message).returns(nil)
        m.processors << processor_a
        m.processors << processor_b
        m.call(message).should == message
      end
    end
  end

  describe "reading messages from an input" do
    it "passes them to the processors until the input returns nil" do
      m = Metaphor.new
      m1 = "Hello"
      m2 = "Metaphor"
      processor = stub_everything('Processor')
      processor.expects(:call).once.with(m1)
      processor.expects(:call).once.with(m2)
      m.processors << processor
      input = stub_everything('Input')
      input.expects(:gets).times(3).returns(m1, m2, nil)
      m.call(input)
    end
  end
end
