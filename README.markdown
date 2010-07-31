Metaphor
========

From the Greek: μεταφορά - metaphora, meaning "transfer"


Running Metaphor
----------------

Use from the command line:

    metaphor --processor /path/to/foo.rb \
             --processor /path/to/bar.rb \
             --processor /path/to/baz.rb \
             --processor stdout
             /path/to/stdin_input.rb

The last argument here is for the input source.

If a full path is not given for processors, metaphor will look in
lib/processor for a file called eg lib/processor/stdout_processor.rb.
Processors are run in the order that they are defined on the command
line.

If you are writing your own processors, check out the Programming with
Metaphor section below.

Programming with Metaphor
-------------------------

    metaphor = Metaphor.new
    metaphor.processors << Foo.new
    metaphor.processors << Bar.new
    metaphor.processors << Baz.new
    metaphor.processors << StdoutProcessor.new

    # Process one message
    metaphor.process(headers, body) # => [ new_headers, new_body ]
                                    # => false (if halted by processor)

    # Process messages from this class until the Ruby VM is killed
    metaphor.process(StdinInput.new)


Classes used for input must respond to #get and return an array of headers
and the message body:

    class StdinInput
      def get
        # return an array like this:
        [
          { "header" => "value", ... }, # Message headers
          "body"                        # Message body
        ]
      end
    end

Classes used as processors must respond to #process(headers, body):

    class StdoutProcessor
      def process(headers, body)
        puts "Headers: #{headers.inspect}"
        puts "Body   : #{body.inspect}"
      end
    end

The return value of #process control what happens to the message. If the
proccesor returns:
  * An array of headers and the message body
    - they passed to the next processor
  * Boolean false (or something that is === to it)
    - Metaphor stops processing this message and discards it
  * Any other value that is not false
    - Metaphor passes the same headers and message that were passed into
      this processor to the next processor in the chain


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