class EventsController < ApplicationController
  before_action :set_event, only: %i[edit update destroy]

  def index
    @events = Event.where(start: params[:start]..params[:end])
  end

  def new
    @event = Event.new
  end

  def edit; end

  def create
    @event = Event.new(event_params)
    if @event.valid?
      @recurring_events = Event.create_events(@event)
    else
      redirect_to root_url
      flash[:danger] = @event.errors.full_messages[0]
    end
  end

  def update
    @events = Event.update_events(@event, event_params)
    return if @events.first.errors.empty?

    redirect_to root_url
    flash[:danger] = @events.first.errors.full_messages[0] # rubocop:disable Rails/ActionControllerFlashBeforeRender
  end

  def destroy
    @deleted_events = Event.delete_events(@event, params[:apply_to_series])
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.expect(event: %i[title start end color recurring_times apply_to_series recurring_schedule])
  end
end
