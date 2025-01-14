module Api
  module V1
    class EventsController < ApplicationController
      protect_from_forgery with: :null_session
      before_action :set_event, only: %i[show update destroy]

      def index
        if params[:start].present? && params[:end].present?
          @events = Event.where(start: params[:start]..params[:end])

          render json: @events
        else
          render status: :bad_request, plain: 'start and end parameters are required'
        end
      end

      def show
        if @event.present?
          render json: @event
        else
          render status: :not_found, json: {}
        end
      end

      def create
        @event = Event.new(event_params)
        if @event.valid?
          @recurring_events = Event.create_events(@event)
          render status: :created, json: @recurring_events
        else
          render status: :bad_request, json: @event.errors.full_messages
        end
      end

      def update
        if @event.present?
          @events = Event.update_events(@event, event_params)
          if @events.first.errors.empty?
            render status: :ok, json: @events
          else
            render status: :bad_request, json: @events.first.errors.full_messages
          end
        else
          render status: :not_found, json: {}
        end
      end

      def destroy
        if @event.present?
          Event.delete_events(@event, params[:apply_to_series])
        else
          render status: :not_found, json: {}
        end
      end

      private

      def set_event
        @event = Event.find_by(id: params[:id])
      end

      def event_params
        params.require(:event).permit(:title, :start, :end, :color,
                                      :recurring_times, :apply_to_series, :recurring_schedule)
      end
    end
  end
end
