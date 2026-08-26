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

  test 'import values' do
    ics_file = file_fixture('home_calendar.ics').read
    ImportICalService.new(ics_file).import

    event = Event.find_by(title: 'TEST')
    assert_equal event.color, Event::DEFAULT_COLOR
    assert event.import_uuid.present?
  end

  test 'idempotent import' do
    ics_file = file_fixture('home_calendar.ics').read
    import_service = ImportICalService.new(ics_file)
    import_service.import

    assert_no_difference 'Event.count' do
      import_service.import
    end
  end

  test 'unsuccessful result' do
    ics_file = file_fixture('invalid_import.ics').read
    result = ImportICalService.new(ics_file).import

    assert_equal result.success?, false
    assert_equal result.error_message, 'Invalid iCalendar input line: Invalid Import'
  end

  test 'it does not create events from invalid file' do
    ics_file = file_fixture('invalid_import.ics').read

    assert_no_difference 'Event.count' do
      ImportICalService.new(ics_file).import
    end
  end

  test 'invalid event' do
    ics_file = file_fixture('invalid_event.ics').read
    result = ImportICalService.new(ics_file).import

    assert_equal result.success?, false
    assert_equal result.error_message, 'Validation failed: End can\'t be before start'
  end
end
