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

  test 'should update multiple events do' do
    event = Event.new(
      title: 'test',
      start: Time.zone.now,
      end: 2.hours.from_now,
      recurring_days: 2
    )
    event_params = { title: 'updated title', color: 'Green', apply_to_series: '1' }

    RecurringService.create_events(event)
    events = RecurringService.update_events(event, event_params)

    assert_equal 3, Event.where(
      recurring_uuid: events[0].recurring_uuid,
      title: 'updated title',
      color: 'Green'
    ).size
  end

  test 'should update single event' do
    event = Event.new(
      title: 'test',
      start: Time.zone.now,
      end: 2.hours.from_now
    )
    event_params = { title: 'updated title', color: 'Green' }

    RecurringService.create_events(event)
    events = RecurringService.update_events(event, event_params)

    assert_equal 1, events.size
    assert_equal 'updated title', events[0].title
    assert_equal 'Green', events[0].color
  end
end
