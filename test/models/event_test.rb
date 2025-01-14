require 'test_helper'

class EventTest < ActiveSupport::TestCase
  test 'should validate presence of start' do
    event = Event.new

    assert_not event.valid?
    assert_equal ["can't be blank"], event.errors[:start]
  end

  test 'should validate presence of end' do
    event = Event.new

    assert_not event.valid?
    assert_equal ["can't be blank"], event.errors[:end]
  end

  test 'should not be valid when end is before start' do
    event = Event.new(start: 2.hours.from_now, end: Time.zone.now)

    assert_not event.valid?
  end

  test 'should be valid when the end isa after start' do
    event = Event.new(start: Time.zone.now, end: 2.hours.from_now)

    assert event.valid?
  end

  test 'should not be valid when the recurring event is greater than 24 hours' do
    event = Event.new(
      start: Time.zone.now,
      end: 2.days.from_now,
      recurring_times: 2
    )

    assert_not event.valid?
  end

  test 'should be valid when the recurring event is less than 24 hours' do
    event = Event.new(
      start: Time.zone.now,
      end: 2.hours.from_now,
      recurring_times: 2
    )

    assert event.valid?
  end

  test 'should be valid when the recurring event is not present' do
    event = Event.new(
      start: Time.zone.now,
      end: 2.days.from_now
    )

    assert event.valid?
  end

  test 'should create recurring events' do
    event = Event.new(
      title: 'test',
      start: Time.zone.now,
      end: 2.hours.from_now,
      recurring_times: 2
    )

    recurring_events = Event.create_events(event)

    assert_equal 3, recurring_events.size
    assert_equal 3, Event.where(recurring_uuid: recurring_events[0].recurring_uuid).size
    assert_not_nil recurring_events[0].recurring_uuid
  end

  test 'should create weekly events' do
    event_start = Time.zone.now
    event_end = 2.hours.from_now

    event = Event.new(
      title: 'test',
      start: event_start,
      end: event_end,
      recurring_times: 2,
      recurring_schedule: 'weekly'
    )

    recurring_events = Event.create_events(event)

    assert_equal 3, recurring_events.size
    assert_equal Event.order(start: :desc).first.start.to_i - 2.weeks, event_start.to_i
  end

  test 'should create monthly events' do
    event_start = Time.zone.now
    event_end = 2.hours.from_now

    event = Event.new(
      title: 'test',
      start: event_start,
      end: event_end,
      recurring_times: 3,
      recurring_schedule: 'monthly'
    )

    recurring_events = Event.create_events(event)

    assert_equal 4, recurring_events.size
    assert_equal (Event.order(end: :desc).first.end - 3.months).to_i, event_end.to_i
  end

  test 'should create events every 2 weeks' do
    event_start = Time.zone.now
    event_end = 2.hours.from_now

    event = Event.new(
      title: 'test',
      start: event_start,
      end: event_end,
      recurring_times: 4,
      recurring_schedule: 'every 2 weeks'
    )

    recurring_events = Event.create_events(event)

    assert_equal 5, recurring_events.size
    assert_equal (Event.order(start: :desc).first.start - 8.weeks).to_i, event_start.to_i
  end

  test 'should not create recurring events when recurring days is not present' do
    event = Event.new(
      title: 'test',
      start: Time.zone.now,
      end: 2.hours.from_now
    )

    recurring_events = Event.create_events(event)

    assert_equal 1, recurring_events.size
    assert_nil recurring_events[0].recurring_uuid
  end

  test 'should update multiple events do' do
    event = Event.new(
      title: 'test',
      start: Time.zone.now,
      end: 2.hours.from_now,
      recurring_times: 2
    )
    event_params = { title: 'updated title', color: 'Green', apply_to_series: '1' }

    Event.create_events(event)
    events = Event.update_events(event, event_params)

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

    Event.create_events(event)
    events = Event.update_events(event, event_params)

    assert_equal 1, events.size
    assert_equal 'updated title', events[0].title
    assert_equal 'Green', events[0].color
  end
end
