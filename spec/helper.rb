if ENV["CI"]
  require 'simplecov'
  require 'coveralls'

  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter
  ]
  SimpleCov.start
end

require 'active_support/concern'
require 'active_record'
require 'mongoid'
require 'remember_me'
require 'rspec'

