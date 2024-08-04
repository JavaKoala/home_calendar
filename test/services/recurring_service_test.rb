require 'test_helper'

class RecurringServiceTest < ActiveSupport::TestCase
  test 'should create recurring events' do
    event = Event.new(
      title: 'test',
      start: Time.zone.now,
      end: 2.hours.from_now,
      recurring_days: 2
    )

    recurring_events = RecurringService.create_events(event)

    assert_equal 3, recurring_events.size
  end

  test 'should not create recurring events when recurring days is not present' do
    event = Event.new(
      title: 'test',
      start: Time.zone.now,
      end: 2.hours.from_now
    )

    recurring_events = RecurringService.create_events(event)

    assert_equal 1, recurring_events.size
  end
end
