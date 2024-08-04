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
    assert_equal 3, Event.where(recurring_uuid: recurring_events[0].recurring_uuid).size
    assert_not_nil recurring_events[0].recurring_uuid
  end

  test 'should not create recurring events when recurring days is not present' do
    event = Event.new(
      title: 'test',
      start: Time.zone.now,
      end: 2.hours.from_now
    )

    recurring_events = RecurringService.create_events(event)

    assert_equal 1, recurring_events.size
    assert_nil recurring_events[0].recurring_uuid
  end
end
