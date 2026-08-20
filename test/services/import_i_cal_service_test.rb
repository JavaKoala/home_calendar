require 'test_helper'

class ImportICalServiceTest < ActiveSupport::TestCase
  test 'creates event' do
    ics_file = file_fixture('home_calendar.ics').read

    assert_difference 'Event.count' do
      ImportICalService.new(ics_file).import
    end
  end
end
