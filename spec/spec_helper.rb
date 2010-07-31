require 'bundler'
Bundler.setup
require 'metaphor'
require 'timecop'

Spec::Runner.configure do |config|
  config.mock_with :mocha
  config.after(:each) do
    Timecop.return
  end
end