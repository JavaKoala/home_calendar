require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'
require 'capybara/minitest'

class ActiveSupport::TestCase
  include Capybara::DSL
  include Capybara::Minitest::Assertions
  Capybara.default_driver = :selenium_chrome_headless
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def teardown
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end
