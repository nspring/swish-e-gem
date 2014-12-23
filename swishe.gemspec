# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "swishe"
  s.version = "0.4.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Patrick Gundlach", "Neil Spring"]
  s.date = "2014-12-23"
  s.description = "Wrapper around libswish, a text indexing system."
  s.email = ["nspring@cs.umd.edu"]
  s.extensions = ["ext/extconf.rb"]
  s.extra_rdoc_files = ["README.md", "MIT-LICENSE"]
  s.files = ["lib/swishe.rb", "ext/swish-e.i", "ext/swishe_base.c", "ext/extconf.rb", "ext/MANIFEST", "setup.rb", "test/tc_swishe.rb", "test/unittest.rb", "README.md", "MIT-LICENSE"]
  s.homepage = "https://github.com/nspring/swish-e-gem"
  s.licenses = ["MIT"]
  s.rdoc_options = ["--main", "README.md", "--title", "swish-e ruby bindings documentation"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.14"
  s.summary = "Ruby bindings for swish-e."
  s.test_files = ["test/tc_swishe.rb", "test/unittest.rb"]
end

