class ImportICalService
  ImportResult = Data.define(:success?, :error)

  def initialize(ics_file)
    @ics_file = ics_file
  end

  def import
    events = Icalendar::Event.parse(@ics_file)
    events.each do |event|
      Event.find_or_create_by!(
        start: event.dtstart,
        end: event.dtend,
        title: event.summary
      )
    end

    ImportResult.new(success?: true, error: nil)
  end
end
