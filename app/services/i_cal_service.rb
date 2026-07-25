class ICalService
  def initialize(event_start:, event_end:)
    @event_start = event_start
    @event_end = event_end
  end

  delegate :to_ical, to: :icalendar

  def icalendar
    calendar = Icalendar::Calendar.new
    find_events.each do |event|
      calendar.event do |e|
        e.dtstart = event.start
        e.dtend = event.end
        e.summary = event.title
      end
    end

    calendar
  end

  def find_events
    t = Event.arel_table
    Event.where(t[:start].lteq(@event_end).and(t[:end].gteq(@event_start)))
  end
end
