# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'remember_me/version'

Gem::Specification.new do |spec|
  spec.name          = 'remember_me'
  spec.version       = RememberMe::VERSION
  spec.authors       = ['linyows']
  spec.email         = ['linyows@gmail.com']
  spec.description   = %q{Manages generating and clearing a token for remembering the user from a saved cookie.}
  spec.summary       = %q{RememberMe is a simple remember-me login solution on Rails.}
  spec.homepage      = 'https://github.com/linyows/remember_me'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'awesome_print'

  spec.add_dependency 'rails', '>= 3.2'
  spec.add_dependency 'mongoid', '>= 3'
end
