require 'test_helper'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome do |option|
    option.add_argument('no-sandbox') if ENV['NO_SANDBOX'] == 'true'
  end
end
