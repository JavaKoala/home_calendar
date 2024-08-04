require 'test_helper'

class EventTest < ActiveSupport::TestCase
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
      recurring_days: 2
    )

    assert_not event.valid?
  end

  test 'should be valid when the recurring event is less than 24 hours' do
    event = Event.new(
      start: Time.zone.now,
      end: 2.hours.from_now,
      recurring_days: 2
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
end
