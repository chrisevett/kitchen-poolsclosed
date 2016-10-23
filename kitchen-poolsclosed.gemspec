# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kitchen/driver/poolsclosed_version'

Gem::Specification.new do |spec|
  spec.name          = 'kitchen-poolsclosed'
  spec.version       = Kitchen::Driver::POOLSCLOSED_VERSION
  spec.authors       = ['chris evett']
  spec.email         = ['chris.evett@gmail.com']

  spec.summary       = 'test-kitchen integration for poolsclosed'
  spec.description   = 'http:///www.github.com/chrisevett/poolsclosed'
  spec.homepage      = 'http:///www.github.com/chrisevett/kitchen-poolsclosed'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_dependency 'test-kitchen', '~> 1.4', '>= 1.4.1'
end
