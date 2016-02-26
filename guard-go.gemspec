# -*- encoding: utf-8 -*-
require File.expand_path('../lib/guard/go/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Victor Castell']
  gem.email         = ['victorcoder@gmail.com']
  gem.description   = 'Guard gem for Go'
  gem.summary       = 'Guard gem for launching go files'
  gem.homepage      = ''

  gem.files         = `git ls-files`.split($OUTPUT_RECORD_SEPARATOR)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'guard-go'
  gem.require_paths = ['lib']
  gem.version       = Guard::GoVersion::VERSION

  gem.add_dependency 'guard', '>= 2.13.0'
  gem.add_dependency 'guard-compat', '~> 1.0'
  gem.add_dependency 'sys-proctable', '>= 0.9'
  gem.add_dependency 'childprocess', '>= 0.3'
end
