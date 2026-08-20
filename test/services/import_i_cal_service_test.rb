require 'test_helper'

class ImportICalServiceTest < ActiveSupport::TestCase
  test 'creates event' do
    ics_file = file_fixture('home_calendar.ics').read

    assert_difference 'Event.count' do
      ImportICalService.new(ics_file).import
    end
  end

  test 'idempotent import' do
    ics_file = file_fixture('home_calendar.ics').read
    import_service = ImportICalService.new(ics_file)
    import_service.import

    assert_no_difference 'Event.count' do
      import_service.import
    end
  end
end
