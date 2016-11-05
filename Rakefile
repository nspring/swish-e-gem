require "rdoc/task"
require "rake/testtask"
require "rubygems/package_task"

SWE_VERSION="0.4.3"

task :default => [:test]

Rake::TestTask.new do |test|
  test.libs       << "test"
  test.test_files =  [ "test/unittest.rb" ]
end

Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_files.include( "README.md","MIT-LICENSE","lib/" )
  rdoc.main     = "README.md"
  rdoc.rdoc_dir = "../../webpage/rdoc"
  rdoc.title    = "swish-e ruby bindings documentation"
end


spec = Gem::Specification.new do |s|
  s.name = "swishe" 
  s.version = SWE_VERSION
  s.authors = [ "Patrick Gundlach", "Neil Spring" ]
  s.description = "Wrapper around libswish, a text indexing system." 
  s.email = [ "nspring@cs.umd.edu" ]
  s.homepage = "https://github.com/nspring/swish-e-gem" 
  s.platform = Gem::Platform::RUBY 
  s.summary = "Ruby bindings for swish-e." 
  s.has_rdoc = true
  s.extra_rdoc_files = ["README.md", "MIT-LICENSE"]
  s.rdoc_options    << "--main" << "README.md" << "--title" << "swish-e ruby bindings documentation"
  s.files = FileList["lib/**/*rb", "ext/swish-e.i", "ext/swishe_base.c", "ext/extconf.rb", "setup.rb"]
  s.extensions = ["ext/extconf.rb"] 
  s.license = 'MIT'
  s.test_files = Dir["test/*.rb"] 
end 

Gem::PackageTask.new(spec) do |pkg|
  pkg.need_zip = true
  pkg.need_tar = true
end

file "swishe.gemspec" => "./pkg/swishe-#{SWE_VERSION}.gem" do |t|
     sh "gem specification ./pkg/swishe-0.4.3.gem --ruby > swishe.gemspec"
end
