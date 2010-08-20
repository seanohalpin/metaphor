require 'spec_helper'
require 'metaphor/processor/wiretap'

describe Metaphor::Processor::Wiretap do
  before(:each) do
    @default_destination = stub_everything('Default Destination')
    @wiretap_destination  = stub_everything('Wiretap Destination')
    @wiretap = Metaphor::Processor::Wiretap.new @default_destination,
                                                @wiretap_destination
  end

  it "is inactive by default" do
    @wiretap.should_not be_active
  end

  it "can be activated" do
    @wiretap.activate
    @wiretap.should be_active
  end

  describe "when inactive" do
    it "routes messages to only the default destination" do
      message = [ { 'x-test' => 'default' }, "test message" ]
      @wiretap_destination.expects(:process).never
      @default_destination.expects(:process).once.with(*message)
      @wiretap.process(*message)
    end
  end

  describe "when active" do
    before(:each) do
      @wiretap.activate
    end

    it "routes the same message to both destinations" do
      message = [ { 'x-test' => 'wiretap' }, "test message" ]
      wiretaped_message = [ { 'x-test' => 'wiretaped' }, "wiretaped test message" ]
      route = sequence('route')
      @wiretap_destination.expects(:process).once.with(*message).in_sequence(route).returns(wiretaped_message)
      @default_destination.expects(:process).once.with(*message).in_sequence(route)
      @wiretap.process(*message)
    end

    it "can be deactivated" do
      @wiretap.deactivate
      @wiretap.should_not be_active      
    end
  end

  after(:each) do
    @wiretap = nil
  end
end
