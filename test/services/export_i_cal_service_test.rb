require 'test_helper'

class ExportICalServiceTest < ActiveSupport::TestCase
  test 'returns icalendar object' do
    service = ExportICalService.new(event_start: 1.week.ago, event_end: Time.current)

    assert_kind_of Icalendar::Calendar, service.icalendar
  end

  test 'returns events in window' do
    Event.create!(start: 1.hour.ago, end: Time.current)
    Event.create!(start: 2.weeks.ago, end: 1.week.ago)
    Event.create!(start: 2.weeks.ago, end: 1.week.from_now)

    service = ExportICalService.new(event_start: 1.day.ago, event_end: Time.current)

    assert_equal 2, service.icalendar.events.count
  end

  test 'returns event parameters' do
    event = Event.first

    service = ExportICalService.new(event_start: event.start, event_end: event.end)

    assert_equal service.icalendar.events.first.dtstart, event.start
    assert_equal service.icalendar.events.first.dtend, event.end
    assert_equal service.icalendar.events.first.summary, event.title
    assert_equal service.icalendar.events.first.uid, event.ics_uid
  end
end
