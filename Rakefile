require "rake/rdoctask"
require "rake/testtask"
require "rake/gempackagetask"

SWE_VERSION="0.4"

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
  s.author = "Patrick Gundlach" 
  s.email = "patrick@gundla.ch" 
  s.homepage = "http://rubyforge.org/projects/swishe/" 
  s.platform = Gem::Platform::RUBY 
  s.summary = "Ruby bindings for swish-e." 
  s.has_rdoc = true
  s.extra_rdoc_files = ["README", "MIT-LICENSE"]
  s.rdoc_options    << "--main" << "README" << "--title" << "swish-e ruby bindings documentation"
  s.files = FileList["lib/**/*rb", "ext/swishe_base.c", "ext/extconf.rb", "ext/MANIFEST","setup.rb"]
  s.extensions = ["ext/extconf.rb"] 
end 

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_zip = true
  pkg.need_tar = true
end
