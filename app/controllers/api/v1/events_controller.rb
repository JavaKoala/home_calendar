module Api
  module V1
    class EventsController < ApplicationController
      def show
        @event = Event.find(params[:id])
        render json: @event
      end
    end
  end
end
