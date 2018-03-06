if ENV["CI"]
  require 'simplecov'
  require 'coveralls'

  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter
  ]
  SimpleCov.start
end

require 'rails'
require 'action_controller'
require 'action_view'
require 'active_support/concern'
require 'active_record'
require 'mongoid'
require 'remember_me'
require 'rspec'
require 'rspec/rails'

RSpec.configure do |config|
  config.mock_with :rspec
end

module Example
  class Application < Rails::Application
  end
end

Example::Application.routes.draw do
  post 'signin', to: 'sessions#create'
  get 'signout', to: 'sessions#destroy'
end

class User
  include Mongoid::Document
  include RememberMe::Model
  def save(arg = {})
    true
  end
end
