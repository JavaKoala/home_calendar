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
        render json: @event
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
        @events = Event.update_events(@event, event_params)
        if @events.first.errors.empty?
          render status: :ok, json: @events
        else
          render status: :bad_request, json: @events.first.errors.full_messages
        end
      end

      def destroy
        Event.delete_events(@event, params[:apply_to_series])
      end

      private

      def set_event
        @event = Event.find_by(id: params[:id])

        render status: :not_found, json: {} if @event.blank?
      end

      def event_params
        params.expect(event: %i[title start end color
                                recurring_times apply_to_series recurring_schedule])
      end
    end
  end
end
