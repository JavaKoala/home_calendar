require 'test_helper'

class EventsTest < ActionDispatch::IntegrationTest
  test 'should display recurring options' do
    visit('/')
    first('td', class: 'fc-widget-content').click
    click_on('Recurring')
  end
end
