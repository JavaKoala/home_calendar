class ImportICalService
  ImportResult = Data.define(:success?, :error_message)

  def initialize(ics_file)
    @ics_file = ics_file
  end

  def import
    parser = Icalendar::Parser.new(@ics_file, true)
    calendars = parser.parse
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

    ImportResult.new(success?: true, error_message: nil)
  rescue Icalendar::Parser::ParseError, ActiveRecord::RecordInvalid => e
    ImportResult.new(success?: false, error_message: e.message)
  end
end
