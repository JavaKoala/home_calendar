require 'test_helper'

class ImportICalServiceTest < ActiveSupport::TestCase
  test 'successful result' do
    ics_file = file_fixture('home_calendar.ics').read
    result = ImportICalService.new(ics_file).import

    assert_equal result.success?, true
    assert_nil result.error_message
  end

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

  test 'unsucessful result' do
    ics_file = file_fixture('invalid_import.ics').read
    result = ImportICalService.new(ics_file).import

    assert_equal result.success?, false
    assert_equal result.error_message, 'Invalid iCalendar input line: Invalid Import'
  end
end
