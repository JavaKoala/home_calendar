module Api
  module V1
    class SearchesController < ApplicationController
      protect_from_forgery with: :null_session

      def index
        render json: {}
      end
    end
  end
end
