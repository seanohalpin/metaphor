Metaphor
========

From the Greek: μεταφορά - metaphora, meaning "transfer"


Rationale
---------

As programmers an awful lot of what we do revolves around taking an
input, doing something to it, and sending the result somewhere. Quite a
bit of time is wasted writing the "glue" that transfers the results from
one place to the next. Metaphor aims to provide a standardised and easy
to use way of passing results, leaving you to concentrate on the bit
that's important - the business logic.


Programming with Metaphor
-------------------------

    metaphor = Metaphor.new
    metaphor.processors << Foo.new
    metaphor.processors << Bar.new
    metaphor.processors << Baz.new
    metaphor.processors << Metaphor::Processor::PrintMessage.new

    # Process one message
    metaphor.call("Hello, Metaphor!") # => "Hello, Metaphor!"
                                      # => false (if halted by processor)

    # Process messages from this class until the Ruby VM is killed or the
    # input returns nil
    metaphor.call(StdinInput.new)


Classes used for input must respond to #gets and return a String (or at
least something that quacks like a String):

    class StdinInput
      def gets
        line = STDIN.gets
        line == "" ? nil : line
      end
    end

Classes used as processors must respond to #call(headers, body):

    class PrintMessage
      def call(message)
        puts "Message : #{message.inspect}"
      end
    end

The return value of #call controls what happens to the message. If the
processor returns:

  * false
    - Metaphor stops processing this message and discards it
  * nil
    - Metaphor passes the same object that were passed into the processor to the
      next processor in the chain
  * Anything else
    - Metaphor passes this to the next processor

Contributing
------------

  * Fork the project.
  * Make your feature addition or bug fix.
  * Add tests for it. This is important so I don't break it in a
    future version unintentionally.
  * Commit, do not mess with the Rakefile or Metaphor::VERSION. If you
    want to have your own version, that is fine but bump version in a
    commit by itself I can ignore when I pull.
  * Send me a pull request. Bonus points for topic branches.


Authors
-------

  * Sean O'Halpin
  * Craig R Webster <http://barkingiguana.com/>


License
-------

Released under the MIT licence. See the LICENSE file for details.
