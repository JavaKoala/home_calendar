class RecurringService
  class << self
    def create_events(event)
      events = create_recurring_events(event)
      event.save
      events << event
    end

    def create_recurring_events(event)
      events = []

      return events unless event.recurring_days.present? && event.recurring_days.to_i.positive?

      (1..event.recurring_days.to_i).each do |day|
        events << create_recurring_event(event, day)
      end

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
