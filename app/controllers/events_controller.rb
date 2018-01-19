class EventsController < ApplicationController

  def index
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    @event.save
  end

  private
    def event_params
      params.require(:event).permit(:title, :start, :end, :color)
    end
end