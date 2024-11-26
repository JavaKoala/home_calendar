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

      events = (1..event.recurring_times.to_i).map do |n_time|
        create_recurring_event(event, n_time)
      end

      event.save
      events << event

      events
    end

    def create_recurring_event(event, n_time)
      n_schedule = recurring_schedule(event, n_time)

      recurring_event = event.deep_dup
      recurring_event.start = event.start + n_schedule
      recurring_event.end = event.end + n_schedule
      recurring_event.save

      recurring_event
    end

    def recurring_schedule(event, n_time)
      case event.recurring_schedule
      when 'weekly'
        n_time.weeks
      when 'monthly'
        n_time.months
      when 'every 2 weeks'
        n_time * 2.weeks
      else
        n_time.days
      end
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

    def delete_events(event, apply_to_series)
      deleted_events = if apply_to_series == 'true' && event.recurring_uuid.present?
                         Event.where(recurring_uuid: event.recurring_uuid).pluck(:id)
                       else
                         [event.id]
                       end

      Event.delete(deleted_events)

      deleted_events
    end
  end
end
