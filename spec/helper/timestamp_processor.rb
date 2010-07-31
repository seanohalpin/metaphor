class TimestampProcessor
  attr_reader :received_message_at
  def process(*args)
    @received_message_at = Time.now
  end
end