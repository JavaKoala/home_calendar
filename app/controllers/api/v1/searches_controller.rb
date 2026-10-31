module Api
  module V1
    class SearchesController < ApplicationController
      protect_from_forgery with: :null_session

      def index
        if params[:search].present?
          @events = Event.title_search(params[:search])
          render json: @events
        else
          render json: []
        end
      end
    end
  end
end
