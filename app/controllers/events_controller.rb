class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  def index
    @events = Event.where(start: params[:start]..params[:end])
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    if @event.valid?
      @event.save
    else
      redirect_to root_url
      flash[:danger] = @event.errors.full_messages[0]
    end
  end

  def edit
  end

  def update
    if @event.update(event_params)
    else
      redirect_to root_url
      flash[:danger] = @event.errors.full_messages[0]
    end
  end

  def destroy
    @event.destroy
  end

  private
    def set_event
      @event = Event.find(params[:id])
    end

    def event_params
      params.require(:event).permit(:title, :start, :end, :color)
    end
end