require 'spec_helper'
require 'helper/timestamp_processor'

describe TimestampProcessor do
  it "records when it last received a message" do
    known_time = Time.utc(2010, 1, 1, 12, 0, 0, 0)
    Timecop.freeze known_time
    tsp = TimestampProcessor.new
    tsp.received_message_at.should be_nil
    tsp.process({}, "")
    tsp.received_message_at.should eql(known_time)
  end
end