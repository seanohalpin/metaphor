# Look in the tasks/setup.rb file for the various options that can be
# configured in this Rakefile. The .rake files in the tasks directory
# are where the options are used.

begin
  require 'bones'
  Bones.setup
rescue LoadError
  begin
    load 'tasks/setup.rb'
  rescue LoadError
    raise RuntimeError, '### please install the "bones" gem ###'
  end
end

ensure_in_path 'lib'
require 'metaphor'

task :default => 'spec:run'

PROJ.name = 'metaphor'
PROJ.authors = ["Sean O'Halpin"]
PROJ.email = 'sean.ohalpin@gmail.com'
PROJ.url = 'FIXME (project homepage)'
PROJ.version = Metaphor::VERSION
PROJ.rubyforge.name = 'metaphor'

PROJ.spec.opts << '--color'

PROJ.exclude = %w(tmp$ bak$ ~$ CVS \.svn ^pkg ^doc \.git)
PROJ.exclude << '^tags$'

# EOF
