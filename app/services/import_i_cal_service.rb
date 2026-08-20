class ImportICalService
  ImportResult = Data.define(:success?, :error_message)

  def initialize(ics_file)
    @parser = Icalendar::Parser.new(ics_file, true)
  end

  def import
    calendars = @parser.parse
    import_calendars(calendars)

    ImportResult.new(success?: true, error_message: nil)
  rescue Icalendar::Parser::ParseError, ActiveRecord::RecordInvalid => e
    ImportResult.new(success?: false, error_message: e.message)
  end

  private

  def import_calendars(calendars)
    calendars.each do |calendar|
      events = calendar.events
      events.each do |event|
        Event.find_or_create_by!(
          start: event.dtstart,
          end: event.dtend,
          title: event.summary
        )
      end
    end
  end
end
