require "rdoc/task"
require "rake/testtask"
require "rubygems/package_task"

SWE_VERSION="0.4.2"

task :default => [:test]

Rake::TestTask.new do |test|
  test.libs       << "test"
  test.test_files =  [ "test/unittest.rb" ]
end

Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_files.include( "README","MIT-LICENSE","lib/" )
  rdoc.main     = "README"
  rdoc.rdoc_dir = "../../webpage/rdoc"
  rdoc.title    = "swish-e ruby bindings documentation"
end


spec = Gem::Specification.new do |s|
  s.name = "swishe" 
  s.version = SWE_VERSION
  s.authors = [ "Patrick Gundlach", "Neil Spring" ]
  s.description = "Wrapper around libswish, a text indexing system." 
  s.email = [ "nspring@cs.umd.edu" ]
  # s.homepage = "http://rubyforge.org/projects/swishe/" 
  s.platform = Gem::Platform::RUBY 
  s.summary = "Ruby bindings for swish-e." 
  s.has_rdoc = true
  s.extra_rdoc_files = ["README", "MIT-LICENSE"]
  s.rdoc_options    << "--main" << "README" << "--title" << "swish-e ruby bindings documentation"
  s.files = FileList["lib/**/*rb", "ext/swish-e.i", "ext/swishe_base.c", "ext/extconf.rb", "ext/MANIFEST", "setup.rb"]
  s.extensions = ["ext/extconf.rb"] 
  s.license = 'MIT'
  s.test_files = Dir["test/*.rb"] 
end 

Gem::PackageTask.new(spec) do |pkg|
  pkg.need_zip = true
  pkg.need_tar = true
end
