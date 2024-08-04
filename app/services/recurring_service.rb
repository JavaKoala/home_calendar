class RecurringService
  class << self
    def create_events(event)
      if event.recurring_days.present? && event.recurring_days.to_i.positive?
        create_recurring_events(event)
      else
        create_event(event)
      end
    end

    def create_event(event)
      event.save
      [event]
    end

    def create_recurring_events(event)
      event.recurring_uuid = SecureRandom.uuid

      events = (1..event.recurring_days.to_i).map do |day|
        create_recurring_event(event, day)
      end

      event.save
      events << event

      events
    end

    def create_recurring_event(event, day)
      recurring_event = event.deep_dup
      recurring_event.start = event.start + day.days
      recurring_event.end = event.end + day.days
      recurring_event.save

      recurring_event
    end
  end
end
