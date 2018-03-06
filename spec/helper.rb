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
require 'mongoid'
require 'remember_me'
require 'rspec'
require 'rspec/rails'
require 'securerandom'

RSpec.configure do |config|
  config.mock_with :rspec
  config.infer_base_class_for_anonymous_controllers = true
end

module Example
  class Application < Rails::Application
  end
end

# for secret_key_base
Example::Application.config.secret_key_base = SecureRandom.hex(64)

Example::Application.config.session_options = {}

class User
  include Mongoid::Document
  include RememberMe::Model
  def save(arg = {})
    true
  end
end
