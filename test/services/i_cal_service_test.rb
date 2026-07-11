require 'test_helper'

class ICalServiceTest < ActiveSupport::TestCase
  test 'returns icalendar object' do
    service = ICalService.new(cal_start: 1.week.ago, cal_end: Time.current)

    assert_kind_of Icalendar::Calendar, service.icalendar
  end
end
