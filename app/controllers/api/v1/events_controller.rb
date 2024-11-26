module Api
  module V1
    class EventsController < ApplicationController
      def index
        if params[:start].present? && params[:end].present?
          @events = Event.where(start: params[:start]..params[:end])

          render json: @events
        else
          render status: :bad_request, plain: 'start and end parameters are required'
        end
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
