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
    calendars.each { |calendar| validate_events(calendar.events) }
    calendars.each { |calendar| upsert_events(calendar.events) } # rubocop:disable Style/CombinableLoops
  end

  def validate_events(events)
    events.each do |event|
      Event.new(
        start: event.dtstart,
        end: event.dtend,
        title: event.summary
      ).validate!
    end
  end

  def upsert_events(events)
    event_map(events).each_slice(1000) do |event_batch|
      Event.upsert_all(
        event_batch,
        on_duplicate: :skip
      )
    end
  end

  def event_map(events)
    events.map do |event|
      {
        start: event.dtstart,
        end: event.dtend,
        title: event.summary,
        import_uuid: Digest::UUID.uuid_v5(
          Digest::UUID::DNS_NAMESPACE, "#{event.dtstart.iso8601}#{event.dtend.iso8601}#{event.summary}"
        )
      }
    end
  end
end
