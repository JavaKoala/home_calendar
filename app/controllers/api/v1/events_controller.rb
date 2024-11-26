module Api
  module V1
    class EventsController < ApplicationController
      def index
        @events = Event.where(start: params[:start]..params[:end])

        render json: @events
      end

      def show
        @event = Event.find_by(id: params[:id])

        if @event.present?
          render json: @event
        else
          render status: :not_found, json: {}
        end
      end
    end
  end
end
