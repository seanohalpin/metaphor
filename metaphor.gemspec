lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'metaphor'
 
Gem::Specification.new do |s|
  s.name        = "metaphor"
  s.version     = Metaphor::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = [ "Sean O'Halpin", "Craig R Webster" ]
  s.email       = [ "craig@barkingiguana.com" ]
  s.homepage    = "http://github.com/seanohalpin/metaphor"
  s.summary     = "Generic pipeline processing"
  s.description = "Metaphor provides a standard interface for defining " +
                  "message processors and transformations and a simple " + 
                  "framework for executing them."

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "metaphor"

  s.files        = Dir.glob("{bin,lib}/**/*") + %w(LICENSE README.markdown)
  s.executables  = %w(metaphor)
  s.require_path = 'lib'
end