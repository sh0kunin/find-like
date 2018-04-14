# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'find_like/version'

Gem::Specification.new do |spec|
  spec.name          = 'find_like'
  spec.version       = FindLike::VERSION
  spec.authors       = ['Udit Gupta']
  spec.email         = ['uditgupta.mail@gmail.com']

  spec.summary       = 'unix find_like like command line tool'
  spec.description   = 'The  find_like -like utility recursively descend the directory tree of the given  path  and evaluate the given  expression  for each file in the tree'
  spec.homepage      = 'https://github.com/45minutepromise/find_like-like'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'bin'
  spec.executables   = 'find_like'
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.49.1'
  spec.add_development_dependency 'coveralls'
  spec.add_runtime_dependency     'claide', '~> 1.0'
  spec.add_runtime_dependency     'gli','2.17.1'
  spec.add_development_dependency 'yard', '~> 0.9'
  spec.add_development_dependency 'rack-test', '~> 0.6'
  spec.add_development_dependency 'fileutils'
  spec.add_runtime_dependency 'parallel', '~> 1.12'
  spec.add_development_dependency('test-unit')

end
