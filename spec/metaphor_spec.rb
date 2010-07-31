require 'spec_helper'

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
end