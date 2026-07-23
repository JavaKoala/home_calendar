require 'test_helper'

class ICalServiceTest < ActiveSupport::TestCase
  test 'returns icalendar object' do
    service = ICalService.new(event_start: 1.week.ago, event_end: Time.current)

    assert_kind_of Icalendar::Calendar, service.icalendar
  end

  test 'returns events in window' do
    Event.create(start: 1.hour.ago, end: Time.current)
    Event.create(start: 2.weeks.ago, end: 1.week.ago)

    service = ICalService.new(event_start: 1.day.ago, event_end: Time.current)

    assert_equal service.icalendar.events.count, 1
  end

  test 'returns event parameters' do
    event = Event.create(start: 1.hour.ago, end: Time.current, title: 'Test title')

    service = ICalService.new(event_start: 1.day.ago, event_end: Time.current)

    assert_equal service.icalendar.events.first.dtstart, event.start.to_date
    assert_equal service.icalendar.events.first.dtend, event.end.to_date
    assert_equal service.icalendar.events.first.summary, event.title
  end
end
