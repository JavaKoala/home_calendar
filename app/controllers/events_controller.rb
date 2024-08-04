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
      @recurring_events = RecurringService.create_events(@event)
    else
      redirect_to root_url
      flash[:danger] = @event.errors.full_messages[0]
    end
  end

  def update
    return if @event.update(event_params)

    redirect_to root_url
    flash[:danger] = @event.errors.full_messages[0] # rubocop:disable Rails/ActionControllerFlashBeforeRender
  end

  def destroy
    @event.destroy
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:title, :start, :end, :color, :recurring_days)
  end
end
