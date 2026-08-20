class ImportICalService
  def initialize(ics_file)
    @ics_file = ics_file
  end

  def import
    events = Icalendar::Event.parse(@ics_file)
    events.each do |event|
      Event.create(
        start: event.dtstart,
        end: event.dtend,
        title: event.summary
      )
    end
  end
end
