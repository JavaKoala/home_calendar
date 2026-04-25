require 'simplecov'
SimpleCov.start do
  enable_coverage :branch
  SimpleCov.coverage_dir('test/coverage')
end

require File.expand_path('../config/environment', __dir__)
require 'rails/test_help'
require 'capybara/rails'
require 'capybara/minitest'

module ActiveSupport
  class TestCase
    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all
  end
end
