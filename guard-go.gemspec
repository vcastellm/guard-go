# -*- encoding: utf-8 -*-
require File.expand_path('../lib/guard/go/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Victor Castell"]
  gem.email         = ["victorcoder@gmail.com"]
  gem.description   = %q{Guard gem for Go}
  gem.summary       = %q{Guard gem for launching go files}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "guard-go"
  gem.require_paths = ["lib"]
  gem.version       = Guard::GoVersion::VERSION

  gem.add_dependency 'guard', '>= 2.8.1'
  gem.add_dependency 'sys-proctable', '>= 0.9'
  gem.add_dependency 'childprocess', '>= 0.3'
end
