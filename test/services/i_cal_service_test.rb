require 'test_helper'

class ICalServiceTest < ActiveSupport::TestCase
  test 'returns icalendar object' do
    service = ICalService.new(event_start: 1.week.ago, event_end: Time.current)

    assert_kind_of Icalendar::Calendar, service.icalendar
  end
end
