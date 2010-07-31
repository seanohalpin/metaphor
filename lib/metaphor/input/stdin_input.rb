class Metaphor
  module Input
    class StdinInput
      def initialize(source = STDIN, prompt = STDOUT)
        @source = source
        @prompt = prompt
      end

      def get
        @prompt.puts "Enter headers in the format header:value."
        @prompt.puts "Each header:value pair should be followed by a newline."
        @prompt.puts "When you're done enter a blank line."
        headers = {}
        loop do
          line = @source.readline.to_s.strip 
          break if line == ""
          header, value = line.split(/:/, 2).map{|s|s.strip}
          headers[header] = value
        end

        @prompt.puts "Enter the message body."
        @prompt.puts "When you're done enter a blank line."
        body = []
        loop do
          line = @source.readline.to_s.strip
          break if line == ""
          body << line
        end

        [ headers, body.join("\n") ]
      end
    end
  end
end