class RecurringService
  class << self
    def create_events(event)
      if event.recurring_times.present? && event.recurring_times.to_i.positive?
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

      events = (1..event.recurring_times.to_i).map do |day|
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

    def update_events(event, event_params)
      if event_params[:apply_to_series] == '1' && event.recurring_uuid.present?
        events = Event.where(recurring_uuid: event.recurring_uuid)
        events.update_all(title: event_params[:title], color: event_params[:color])

        events
      else
        event.update(event_params)

        [event]
      end
    end
  end
end
