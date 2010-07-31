require 'bundler'
Bundler.setup
require 'metaphor'

Spec::Runner.configure do |config|
  config.mock_with :mocha
end